name             "lampbase"
version          "0.0.4"
maintainer       "Adam Pancutt"
maintainer_email "adam@pancutt.com"
license          "Apache 2.0"
description      "Base LAMP-stack for a local development environment."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))

%w{ ubuntu debian centos redhat }.each do |os|
  supports os
end

depends "apache2"
depends "database"
depends "php"
depends "memcached"
depends "mysql", "< 6.0"
depends "yum-epel"
