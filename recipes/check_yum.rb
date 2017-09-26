#
# Cookbook Name:: opsview
# Recipe:: check_yum
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
python_runtime "2" do
  provider :system
end

nrpe_plugin "check_yum" do
  remote_file true
  source "https://raw.githubusercontent.com/HariSekhon/nagios-plugins/25f7e1b66ffa8c63a6ecd5f5d032460599762ac4/check_yum.py"
  checksum "204f06278cb14ff8f7a9c3e2d438288ccf180cf391c510017b50ba9ee6167551"
  sudo true
end

sudo "nagios_check_yum" do
  user "nagios"

  commands [
    "/usr/local/nagios/libexec/nrpe_local/check_yum",
  ]

  host "ALL"
  nopasswd true
end
