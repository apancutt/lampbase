# The machine-name of your application
default["locallamp"]["app_name"] = "myapp"

# Database credentials for your application
default["locallamp"]["db_name"] = node["locallamp"]["app_name"];
default["locallamp"]["db_user"] = node["locallamp"]["app_name"];
default["locallamp"]["db_pass"] = "#{node["locallamp"]["app_name"]}pass"

# If you need to override any files/templates provided by this cookbook, create your own cookbook containing the
# overridden file(s) and specify the name of your cookbook in the corresponding attribute.
default["locallamp"]["ca_key_file_cookbook"] = false
default["locallamp"]["ca_crt_file_cookbook"] = false
default["locallamp"]["openssl_cnf_tmpl_cookbook"] = false
default["locallamp"]["vhost_tmpl_cookbook"] = false
