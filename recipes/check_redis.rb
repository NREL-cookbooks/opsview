#
# Cookbook Name:: opsview
# Recipe:: check_redis
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

rvm_gem "redis"

if(node[:languages][:ruby][:version].to_f < 1.9)
  rvm_gem "SystemTimer"
end

nrpe_plugin "check_redis" do
  source "nagios_plugins/nagios-check-redis/check_redis"
end
