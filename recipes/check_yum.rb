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

# https://github.com/opinkerfi/nagios-plugins/blob/master/check_yum/check_yum
# Fork of: https://code.google.com/p/check-yum/
# This fork includes a couple handy features:
# - "long-output" option to show the packages with security issues.
# - Performance output to track number of security updates over time.
nrpe_plugin "check_yum" do
  remote_file true
  source "https://raw.githubusercontent.com/opinkerfi/nagios-plugins/944d47e18e5b03d514a5e3a56495b7817d424b97/check_yum/check_yum"
  checksum "f87ed2321adedae350b5c4dc4f77127963d694e6ac29b639b43e8f5a86f99d86"
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
