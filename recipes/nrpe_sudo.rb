#
# Cookbook Name:: opsview
# Recipe:: nrpe_sudo
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

sudo "nagios_defaults" do
  template "nagios_defaults.erb"
end
