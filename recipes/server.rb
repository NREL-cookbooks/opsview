#
# Cookbook Name:: opsview
# Recipe:: server
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql::server"
include_recipe "yum::epel"
include_recipe "yum::opsview"

package "opsview" do
  action :upgrade
  notifies :restart, "service[opsview]"
  notifies :restart, "service[opsview-agent]"
  notifies :restart, "service[opsview-web]"
end

file "/etc/httpd/conf.d/02_auth_tkt.conf" do
  action :delete
end

apache_module "auth_tkt"

directory node[:opsview][:backup][:dir] do
  owner "nagios"
  group "nagcmd"
  mode "0750"
  recursive true
end

template "/usr/local/nagios/etc/opsview.conf" do
  source "opsview.conf.erb"
  owner "nagios"
  group "nagios"
  mode "0640"
end

execute "chown -f -R nagios:nagios /usr/local/nagios/bin /usr/local/nagios/configs"

chef_gem "mysql2"

execute "db_mysql" do
  command "/usr/local/nagios/bin/db_mysql -u root -p '#{node[:mysql][:server_root_password]}'"
end

execute "db_opsview" do
  command "/usr/local/nagios/bin/db_opsview db_install"
  not_if do
    require "mysql2"
    client = Mysql2::Client.new(:host => "localhost", :username => node[:opsview][:db][:username], :password => node[:opsview][:db][:password])
    client.query("SELECT COUNT(*) AS count FROM information_schema.tables WHERE table_schema = '#{node[:opsview][:db][:database]}' AND table_name = 'schema_version'").first["count"] > 0
  end
end

execute "db_runtime" do
  command "/usr/local/nagios/bin/db_runtime db_install"
  not_if do
    require "mysql2"
    client = Mysql2::Client.new(:host => "localhost", :username => node[:opsview][:db][:runtime][:username], :password => node[:opsview][:db][:runtime][:password])
    client.query("SELECT COUNT(*) AS count FROM information_schema.tables WHERE table_schema = '#{node[:opsview][:db][:runtime][:database]}' AND table_name = 'schema_version'").first["count"] > 0
  end
end

execute "gen_config" do
  command "/usr/local/nagios/bin/rc.opsview gen_config"
  not_if { File.exists?("/usr/local/nagios/etc/nagios.cfg") }
end

service "opsview" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

service "opsview-agent" do
  supports :restart => true
  action [:enable, :start]
end

service "opsview-web" do
  supports :status => true, :restart => true
  action [:enable, :start]
end
