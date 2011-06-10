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

# FIXME: Use yum package when they officially support RHEL6.
#package "opsview"

rpms = [
  { :package => "opsview-base", :file => "opsview-base-3.11.3.6091-1.el6.#{node[:kernel][:machine]}.rpm" },
  { :package => "opsview-perl", :file => "opsview-perl-3.11.3.431-1.el6.#{node[:kernel][:machine]}.rpm" },
  { :package => "opsview-reports", :file => "opsview-reports-2.2.4.258-1.el6.noarch.rpm" },
  { :package => "opsview-core", :file => "opsview-core-3.11.3.6091-1.el6.noarch.rpm" },
  { :package => "opsview-web", :file => "opsview-web-3.11.3.6091-1.el6.noarch.rpm" },
  { :package => "opsview", :file => "opsview-3.11.3.6091-1.el6.noarch.rpm" },
]

rpms.each do |rpm|
  cookbook_file "#{Chef::Config[:file_cache_path]}/#{rpm[:file]}" do
    source "rhel6/#{rpm[:file]}"
    backup false
  end

  package rpm[:package] do
    source "#{Chef::Config[:file_cache_path]}/#{rpm[:file]}"
    options "--nogpgcheck" 
  end
end

# FIXME: The RPM install should create this required user and group. See if
# that works when RHEL6 official packages are released.
group "nagios"
user "nagios" do
  shell "/bin/bash"
  system true
  gid "nagios"
  home "/var/log/nagios"
end

group "nagcmd" do
  members ["nagios"]
  append true
end

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

execute "chown -R nagios:nagios /usr/local/nagios/bin /usr/local/nagios/configs"
execute "chown -R nagios:nagcmd /tmp/opsview"

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
