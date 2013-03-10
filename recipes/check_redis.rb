#
# Cookbook Name:: opsview
# Recipe:: check_redis
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rbenv::system"

rbenv_gem "redis"

if(node[:languages][:ruby][:version].to_f < 1.9)
  rbenv_gem "SystemTimer"
end

nrpe_plugin "check_redis" do
  source "nagios_plugins/nagios-check-redis/check_redis"
  env "env PATH=#{node[:rbenv][:root_path]}/shims:#{node[:rbenv][:root_path]}/bin:$PATH "
end
