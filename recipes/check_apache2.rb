#
# Cookbook Name:: opsview
# Recipe:: check_apache2
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

nrpe_plugin "check_apache2"
