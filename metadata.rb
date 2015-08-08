name             "lampbase"
version          "1.0.0"
maintainer       "Adam Pancutt"
maintainer_email "adam@pancutt.com"
license          "Apache 2.0"
description      "Base LAMP-stack for a local development environment."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))

%w{ ubuntu debian centos redhat }.each do |os|
    supports os
end

depends "apache2",         "~> 3.1"
depends "composer",        "~> 2.1"
depends "database",        "~> 4.0"
depends "memcached",       "~> 1.7"
depends "mysql",           "~> 6.0"
depends "mysql2_chef_gem", "~> 1.0"
depends "nodejs",          "~> 2.4"
depends "php",             "~> 1.5"
depends "redisio",         "~> 2.3"
