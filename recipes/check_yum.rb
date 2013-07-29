#
# Cookbook Name:: opsview
# Recipe:: check_yum
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "opsview::nrpe_sudo"
include_recipe "python"

sudo "nagios_check_yum" do
  user "nagios" 

  commands [
    "/usr/local/nagios/libexec/nrpe_local/check_yum",
  ]

  host "ALL"
  nopasswd true
end

nrpe_plugin "check_yum" do
  sudo true
end
