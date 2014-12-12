#
# Cookbook Name:: opsview
# Recipe:: check_yum
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "python"

# https://code.google.com/p/check-yum/
nrpe_plugin "check_yum" do
  remote_file true
  source "https://check-yum.googlecode.com/git-history/d5aed5e81ea8e1ff116da12e38c543a57aacfa6d/check_yum"
  checksum "6f1b7922ce766ec8823eedfa3c132e88741e5121c6031590b46e5e85eb798556"
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
