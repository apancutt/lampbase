include_recipe "apache2"
include_recipe "apache2::mod_ssl"

# Disable SendFile feature due to issues with VirtualBox and Apache
# See: http://docs.vagrantup.com/v2/synced-folders/virtualbox.html
apache_conf "sendfile"

# Create SSL certificates

directory "#{node["apache"]["dir"]}/ssl" do
    owner "root"
    group "root"
    mode "0700"
    action :create
end

cookbook_file "ca.key" do
    path "#{node["apache"]["dir"]}/ssl/ca.key"
    owner "root"
    group "root"
    mode "0600"
    cookbook node["lampbase"]["apache_ca_key_file_cookbook"] if node["lampbase"]["apache_ca_key_file_cookbook"]
    action :create_if_missing
end

cookbook_file "ca.crt" do
    path "#{node["apache"]["dir"]}/ssl/ca.crt"
    owner "root"
    group "root"
    mode "0644"
    cookbook node["lampbase"]["apache_ca_crt_file_cookbook"] if node["lampbase"]["apache_ca_crt_file_cookbook"]
    action :create_if_missing
end

unless ::File.exists?("#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.crt")

    template "#{node["apache"]["dir"]}/ssl/openssl.cnf" do
        source "openssl.cnf.erb"
        cookbook node["lampbase"]["apache_openssl_cnf_tmpl_cookbook"] if node["lampbase"]["apache_openssl_cnf_tmpl_cookbook"]
    end

    execute "apache_openssl_create_key" do
        command "openssl genrsa -out '#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.key' 4096"
    end

    execute "apache_openssl_create_csr" do
        command "openssl req -sha256 -new -key '#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.key' -out '#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.csr' -config '#{node["apache"]["dir"]}/ssl/openssl.cnf' -extensions v3_req -subj '/CN=#{node["fqdn"]}'"
    end

    execute "apache_openssl_create_crt" do
        command "openssl x509 -req -days 36524 -CA '#{node["apache"]["dir"]}/ssl/ca.crt' -CAkey '#{node["apache"]["dir"]}/ssl/ca.key' -CAcreateserial -in '#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.csr' -out '#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.crt' -extfile '#{node["apache"]["dir"]}/ssl/openssl.cnf' -extensions v3_req"
    end

    file "#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.key" do
      owner "root"
      group "root"
      mode "0600"
    end

    file "#{node["apache"]["dir"]}/ssl/#{node["fqdn"]}.crt" do
        owner "root"
        group "root"
        mode "0644"
    end

    ["ca.srl", "#{node["fqdn"]}.csr", "openssl.cnf"].each do |filename|
        file "#{node["apache"]["dir"]}/ssl/#{filename}" do
            action :delete
        end
    end

end

web_app node["fqdn"] do
  template "vhost.conf.erb"
  cookbook node["lampbase"]["apache_vhost_tmpl_cookbook"] if node["lampbase"]["apache_vhost_tmpl_cookbook"]
end
