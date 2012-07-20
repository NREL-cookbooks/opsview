#
# Cookbook Name:: opsview
# Recipe:: check_redis
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rbenv::global_version"

rbenv_gem "redis" do
  ruby_version node[:rbenv][:install_global_version]
end

if(node[:languages][:ruby][:version].to_f < 1.9)
  rbenv_gem "SystemTimer" do
    ruby_version node[:rbenv][:install_global_version]
  end
end

nrpe_plugin "check_redis" do
  source "nagios_plugins/nagios-check-redis/check_redis"
  env "env PATH=#{node[:rbenv][:install_prefix]}/rbenv/shims:#{node[:rbenv][:install_prefix]}/rbenv/bin:$PATH "
end
