include_recipe "php"
include_recipe "memcached"


# Install additional PHP modules

case node["platform_family"]

  when "rhel"

    include_recipe "yum-epel"

    %w{ php-mcrypt php-memcached php-mysql php-pdo }.each do |pkg|
      package pkg do
        action :install
      end
    end

  when "debian"

    %w{ php5-mcrypt php5-memcached php5-mysql }.each do |pkg|
      package pkg do
        action :install
      end
    end

    execute "enable_php_mcrypt" do
      command "php5enmod mcrypt"
      not_if "php5query -s apache2 -q -m mcrypt"
      notifies :reload, "service[apache2]", :delayed
    end

end
