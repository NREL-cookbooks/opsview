#
# Cookbook Name:: opsview
# Recipe:: server
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql::server"

# FIXME: Use opsview repo when they officially support RHEL6.
#include_recipe "yum::opsview"

# Seems to be a missing dependency, at least under RHEL6.
#
# FIXME: Check to see if this is included whenever Opsview officially supports
# RHEL6.
if platform?("redhat", "centos", "fedora")
  package "rrdtool-perl"
end

#package "opsview"

remote_directory "#{Chef::Config[:file_cache_path]}/opsview/rhel6" do
  source "rhel6"
  files_backup 0
  recursive true
end

package "opsview-base" do
  source "#{Chef::Config[:file_cache_path]}/opsview/rhel6/opsview-base-3.11.2.6057-1.el6.x86_64.rpm"
  options "--nogpgcheck" 
end

package "opsview-perl" do
  source "#{Chef::Config[:file_cache_path]}/opsview/rhel6/opsview-perl-3.11.2.426-1.el6.x86_64.rpm"
  options "--nogpgcheck" 
end

package "opsview-reports" do
  source "#{Chef::Config[:file_cache_path]}/opsview/rhel6/opsview-reports-2.2.4.258-1.el6.noarch.rpm"
  options "--nogpgcheck" 
end

package "opsview-core" do
  source "#{Chef::Config[:file_cache_path]}/opsview/rhel6/opsview-core-3.11.2.6057-1.el6.noarch.rpm"
  options "--nogpgcheck" 
end

package "opsview-web" do
  source "#{Chef::Config[:file_cache_path]}/opsview/rhel6/opsview-web-3.11.2.6057-1.el6.noarch.rpm"
  options "--nogpgcheck" 
end

package "opsview" do
  source "#{Chef::Config[:file_cache_path]}/opsview/rhel6/opsview-3.11.2.6057-1.el6.noarch.rpm"
  options "--nogpgcheck" 
end






group "nagios" do
  # Workaround lack of option to enable --system
  group_name "--system nagios"
  not_if { Etc.getgrnam("nagios") }
end

user "nagios" do
  system true
  gid "nagios"
  home "/var/log/nagios"
  manage_home true
  shell "/bin/bash"
end

group "nagcmd" do
  # Workaround lack of option to enable --system
  group_name "--system nagcmd"
  not_if { Etc.getgrnam("nagcmd") }

  members ["nagios"]
  append
end

template "/usr/local/nagios/etc/opsview.conf" do
  source "opsview.conf.erb"
  owner "nagios"
  group "nagios"
  mode "0640"
end

execute "chown -R nagios:nagios /usr/local/nagios/bin /usr/local/nagios/configs"

gem_package "mysql2"

execute "db_mysql" do
  command "/usr/local/nagios/bin/db_mysql -u root -p '#{node[:mysql][:server_root_password]}'"
end

execute "db_opsview" do
  command "/usr/local/nagios/bin/db_opsview db_install"
  not_if do
    require "mysql2"
    client = Mysql2::Client.new(:host => node[:opsview][:db][:host], :username => node[:opsview][:db][:username], :password => node[:opsview][:db][:password])
    client.query("SELECT COUNT(*) AS count FROM information_schema.tables WHERE table_schema = '#{node[:opsview][:db][:database]}' AND table_name = 'schema_version'").first["count"] > 0
  end
end

execute "db_runtime" do
  command "/usr/local/nagios/bin/db_runtime db_install"
  not_if do
    require "mysql2"
    client = Mysql2::Client.new(:host => node[:opsview][:db][:runtime][:host], :username => node[:opsview][:db][:runtime][:username], :password => node[:opsview][:db][:runtime][:password])
    client.query("SELECT COUNT(*) AS count FROM information_schema.tables WHERE table_schema = '#{node[:opsview][:db][:runtime][:database]}' AND table_name = 'schema_version'").first["count"] > 0
  end
end

execute "db_odw" do
  command "/usr/local/nagios/bin/db_odw db_install"
  not_if do
    require "mysql2"
    client = Mysql2::Client.new(:host => node[:opsview][:db][:odw][:host], :username => node[:opsview][:db][:odw][:username], :password => node[:opsview][:db][:odw][:password])
    client.query("SELECT COUNT(*) AS count FROM information_schema.tables WHERE table_schema = '#{node[:opsview][:db][:odw][:database]}' AND table_name = 'schema_version'").first["count"] > 0
  end
end

execute "db_reports" do
  command "/usr/local/nagios/bin/db_reports db_install"
  not_if do
    require "mysql2"
    client = Mysql2::Client.new(:host => node[:opsview][:db][:reports][:host], :username => node[:opsview][:db][:reports][:username], :password => node[:opsview][:db][:reports][:password])
    client.query("SELECT COUNT(*) AS count FROM information_schema.tables WHERE table_schema = '#{node[:opsview][:db][:reports][:database]}' AND table_name = 'schema_version'").first["count"] > 0
  end

end

execute "gen_config" do
  command "/usr/local/nagios/bin/rc.opsview gen_config"
  #not_if "/usr/local/nagios/bin/db_reports db_exists"
end

service "opsview" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

service "opsview-web" do
  supports :status => true, :restart => true
  action [:enable, :start]
end
