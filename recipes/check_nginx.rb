#
# Cookbook Name:: opsview
# Recipe:: check_nginx
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

package "wget"
nrpe_plugin "check_nginx"

include_recipe "python"
nrpe_plugin "check_nginx_conn"
