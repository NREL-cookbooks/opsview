#
# Cookbook Name:: opsview
# Recipe:: check_apache2
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

# http://exchange.nagios.org/directory/Plugins/Web-Servers/Apache/check_apache2-2Esh/details
nrpe_plugin "check_apache2" do
  remote_file true
  source "http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=619&cf_id=24"
  checksum "9044ae9bb45230b99bf017637e6df381329d523404201d2791603ce52946aedd"
end
