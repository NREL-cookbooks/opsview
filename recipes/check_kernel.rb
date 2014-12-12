#
# Cookbook Name:: opsview
# Recipe:: check_kernel
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

# https://github.com/onnozweers/Nagios-plugins
nrpe_plugin "check_kernel" do
  remote_file true
  source "https://raw.githubusercontent.com/GUI/Nagios-plugins/8cac3c1dbb7a4241d491234d64b074aad7a1ea85/check_kernel"
  checksum "b11cda56f2e15ec465b7869f3ff93543d3e92959d88bbc25d219209f47914a23"
end
