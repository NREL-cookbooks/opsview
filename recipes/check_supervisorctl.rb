#
# Cookbook Name:: opsview
# Recipe:: check_supervisorctl
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

# https://github.com/stevelippert/check_supervisorctl
nrpe_plugin "check_supervisorctl" do
  remote_file true
  source "https://raw.githubusercontent.com/GUI/check_supervisorctl/2f8e5ac587fed0e4d9413482d5cee0c5a4e6db49/check_supervisorctl.sh"
  checksum "98092a526d813ffb35ab2f5fb7bd31245ee98448d084e05f4a2a71299d2d738b"
  sudo true
end

sudo "nagios_check_supervisorctl" do
  user "nagios"

  commands [
    "/usr/local/nagios/libexec/nrpe_local/check_supervisorctl",
  ]

  host "ALL"
  nopasswd true
end
