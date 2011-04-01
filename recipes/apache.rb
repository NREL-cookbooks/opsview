#
# Cookbook Name:: opsview
# Recipe:: apache
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_proxy"
include_recipe "opsview::server"

group "nagcmd" do
  members [node[:apache][:user]]
  append
end

template "#{node[:apache][:dir]}/sites-available/opsview" do
  source "apache.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, "service[apache2]"
end

apache_site "opsview"
