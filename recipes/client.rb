#
# Cookbook Name:: opsview
# Recipe:: client
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::opsview"

# FIXME
if platform?("redhat", "centos", "fedora")
  package "openssl098e"
end

package "opsview-agent"

service "opsview-agent" do
  supports :restart => true
  action [:enable, :start]
end
