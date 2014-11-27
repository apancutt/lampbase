# The machine-name of your application
default["lampbase"]["app_name"] = "myapp"

# Database credentials for your application
default["lampbase"]["db_name"] = "myapp"
default["lampbase"]["db_username"] = "myapp"
default["lampbase"]["db_password"] = "myapp"

# If you need to override any files/templates provided by this cookbook, create your own cookbook containing the
# overridden file(s) and specify the name of your cookbook in the corresponding attribute.
default["lampbase"]["ca_key_file_cookbook"] = false
default["lampbase"]["ca_crt_file_cookbook"] = false
default["lampbase"]["openssl_cnf_tmpl_cookbook"] = false
default["lampbase"]["vhost_tmpl_cookbook"] = false
