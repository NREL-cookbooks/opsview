#
# Cookbook Name:: opsview
# Recipe:: check_diskstat
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

nrpe_plugin "check_diskstat"
nrpe_plugin "check_all_diskstat"
