include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_ssl"


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
  cookbook node["lampbase"]["ca_key_file_cookbook"] if node["lampbase"]["ca_key_file_cookbook"]
  action :create_if_missing
end

cookbook_file "ca.crt" do
  path "#{node["apache"]["dir"]}/ssl/ca.crt"
  owner "root"
  group "root"
  mode "0644"
  cookbook node["lampbase"]["ca_crt_file_cookbook"] if node["lampbase"]["ca_crt_file_cookbook"]
  action :create_if_missing
end

unless ::File.exists?("#{node["apache"]["dir"]}/ssl/server.crt")

  template "#{node["apache"]["dir"]}/ssl/openssl.cnf" do
    source "openssl.cnf.erb"
    cookbook node["lampbase"]["openssl_cnf_tmpl_cookbook"] if node["lampbase"]["openssl_cnf_tmpl_cookbook"]
  end

  execute "openssl_create_key" do
    command "openssl genrsa -out '#{node["apache"]["dir"]}/ssl/server.key' 4096"
  end
  file "#{node["apache"]["dir"]}/ssl/server.key" do
    owner "root"
    group "root"
    mode "0600"
  end

  execute "openssl_create_csr" do
    command "openssl req -sha256 -new -key '#{node["apache"]["dir"]}/ssl/server.key' -out '#{node["apache"]["dir"]}/ssl/server.csr' -config '#{node["apache"]["dir"]}/ssl/openssl.cnf' -extensions v3_req -subj '/CN=localhost'"
  end

  execute "openssl_create_crt" do
    command "openssl x509 -req -days 36524 -CA '#{node["apache"]["dir"]}/ssl/ca.crt' -CAkey '#{node["apache"]["dir"]}/ssl/ca.key' -CAcreateserial -in '#{node["apache"]["dir"]}/ssl/server.csr' -out '#{node["apache"]["dir"]}/ssl/server.crt' -extfile '#{node["apache"]["dir"]}/ssl/openssl.cnf' -extensions v3_req"
  end
  file "#{node["apache"]["dir"]}/ssl/server.crt" do
    owner "root"
    group "root"
    mode "0644"
  end

  %w{ ca.srl server.csr openssl.cnf }.each do |target|
    file "#{node["apache"]["dir"]}/ssl/#{target}" do
      action :delete
    end
  end

end


# Create the application vhost

web_app node["fqdn"] do
  template "vhost.conf.erb"
  cookbook node["lampbase"]["vhost_tmpl_cookbook"] if node["lampbase"]["vhost_tmpl_cookbook"]
  server_name node["fqdn"]
  allow_override "all"
  docroot "#{node["apache"]["docroot_dir"]}/#{node["fqdn"]}/public"
  ssl_enabled true
  ssl_ca "#{node["apache"]["dir"]}/ssl/ca.crt"
  ssl_crt "#{node["apache"]["dir"]}/ssl/server.crt"
  ssl_key "#{node["apache"]["dir"]}/ssl/server.key"
end
