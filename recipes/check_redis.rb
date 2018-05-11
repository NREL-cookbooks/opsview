#
# Cookbook Name:: opsview
# Recipe:: check_redis
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

rbenv_gem "redis"

nrpe_plugin "check_redis" do
  source "nagios_plugins/nagios-check-redis/check_redis"
  env "PATH=#{node[:rbenv][:root_path]}/shims:#{node[:rbenv][:root_path]}/bin:$PATH"
end
