#
# Cookbook Name:: opsview
# Recipe:: check_mongodb
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

# Enable the built-in check_dns command as a NRPE plugin so we can test DNS
# locally on machines.
nrpe_plugin "check_dns" do
  script_path "/usr/local/nagios/libexec/check_dns"
  cookbook_file false
end
