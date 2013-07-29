#
# Cookbook Name:: opsview
# Recipe:: check_nginx
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
package "wget"

# http://exchange.nagios.org/directory/Plugins/Web-Servers/nginx/check_nginx-2Esh/details
nrpe_plugin "check_nginx" do
  remote_file true
  source "http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=622&cf_id=24"
  checksum "c59897e924069f8b43da6fe19924588bc8cf0c4005c3500143430e76996c7477"
end

# http://exchange.nagios.org/directory/Plugins/Web-Servers/nginx/check_nginx/details
# Locally patched with fixed to performance output.
include_recipe "python"
nrpe_plugin "check_nginx_conn"
