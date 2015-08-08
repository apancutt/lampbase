package "php5-mysql"

mysql_service "default" do
  initial_root_password node["lampbase"]["db_root_password"]
  action [:create, :start]
end

mysql2_chef_gem "default" do
    action :install
end

connection_info = {
    :host => "127.0.0.1",
    :username => "root",
    :password => node["lampbase"]["db_root_password"]
}

mysql_database node["lampbase"]["db_name"] do
    connection connection_info
    encoding node["lampbase"]["db_encoding"]
    collation node["lampbase"]["db_collation"]
    action :create
end

mysql_database_user node["lampbase"]["db_username"] do
    connection connection_info
    password node["lampbase"]["db_password"]
    host node["lampbase"]["db_host"]
    database_name node["lampbase"]["db_name"]
    action :grant
end
