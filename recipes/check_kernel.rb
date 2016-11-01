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
  source "https://raw.githubusercontent.com/onnozweers/Nagios-plugins/d875419d1b2775ec50a2f4b1a765598b6dcc3291/check_kernel"
  checksum "a028b41c9d2213d603ceefe870d5e316308811ceac2be32f7b2dc24d840bdaf7"
end
