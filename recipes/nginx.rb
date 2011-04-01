#
# Cookbook Name:: opsview
# Recipe:: nginx
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::server"

group "nagcmd" do
  members [node[:nginx][:user]]
  append
end

