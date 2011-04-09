#
# Cookbook Name:: opsview
# Recipe:: check_redis
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

gem_package "redis"
gem_package "SystemTimer"

nagios_plugin "check_redis" do
  source "nagios_plugins/nagios-check-redis/check_redis"
end
