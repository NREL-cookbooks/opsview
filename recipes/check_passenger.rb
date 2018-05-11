#
# Cookbook Name:: opsview
# Recipe:: check_passenger
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

sudo "nagios_check_passenger" do
  user "nagios"
  commands [
    "/usr/local/nagios/libexec/nrpe_local/check_passenger",
  ]

  host "ALL"
  nopasswd true
end

nrpe_plugin "check_passenger" do
  sudo true
end
