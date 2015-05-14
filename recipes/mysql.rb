include_recipe "mysql::server"
include_recipe "database"


# Create the application database and user

connection_info = {
  :host     => "127.0.0.1",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

mysql_database node["lampbase"]["db_name"] do
  connection connection_info
  action :create
end

mysql_database_user node["lampbase"]["db_username"] do
  connection connection_info
  password node["lampbase"]["db_password"]
  database_name node["lampbase"]["db_name"]
  action :grant
end
