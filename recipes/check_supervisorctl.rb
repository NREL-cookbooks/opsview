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
  source "https://raw.github.com/stevelippert/check_supervisorctl/13eb322534118cf945d8b6b0ffbd205500b3a17a/check_supervisorctl.sh"
  checksum "2e4c0693553bab4bf63df22b0d56ed57b9d601273f1132fd3e21debae3552cc2"
end
