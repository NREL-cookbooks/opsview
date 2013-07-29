#
# Cookbook Name:: opsview
# Recipe:: check_writable
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "perl::data_random"

nrpe_plugin "check_writable"
