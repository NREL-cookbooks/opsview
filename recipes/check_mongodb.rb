#
# Cookbook Name:: opsview
# Recipe:: check_mongodb
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "python"

package "pymongo"

nrpe_plugin "check_mongodb"
