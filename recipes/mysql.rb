include_recipe "mysql::server"
include_recipe "database::mysql"


# Create the application database and user

connection_info = {
  :host     => "127.0.0.1",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

mysql_database node["locallamp"]["db_name"] do
  connection connection_info
  action :create
end

mysql_database_user node["locallamp"]["db_user"] do
  connection connection_info
  password node["locallamp"]["db_password"]
  database_name node["locallamp"]["db_name"]
  action :grant
end
