#
# Cookbook Name:: opsview
# Recipe:: check_cpu
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "perl"

nrpe_plugin "check_cpu"
