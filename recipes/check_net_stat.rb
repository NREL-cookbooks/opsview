#
# Cookbook Name:: opsview
# Recipe:: check_net_stat
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

# http://exchange.nagios.org/directory/Plugins/System-Metrics/Networking/stat_net-2Epl/details
nrpe_plugin "check_net_stat" do
  remote_file true
  source "http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=2829&cf_id=29"
  checksum "446afe02b29da7200ffdf29b3a7a85270114bfff9cadfe341c21371b60de2f61"
end
