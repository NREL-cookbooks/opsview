#
# Cookbook Name:: opsview
# Recipe:: check_jstat
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

sudo "nagios_check_jstat" do
  user "nagios"
  commands [
    "/usr/local/nagios/libexec/nrpe_local/check_jstat",
  ]

  host "ALL"
  nopasswd true
end

nrpe_plugin "check_jstat" do
  sudo true
  remote_file true
  source "https://raw.githubusercontent.com/Ericbla/check_jstat/f2653866b6381d173d1068b1c03b18474315481f/check_jstat.sh"
  checksum "b838cd59d9ea5a0c2f90489393a796a8bd4b11d3a643cd27dc9a1f9546533d4c"
end

