#
# Cookbook Name:: opsview
# Recipe:: check_elasticsearch
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
python_runtime "2" do
  provider :system
end

python_package "nagioscheck" do
  action :install
end

# https://github.com/anchor/nagios-plugin-elasticsearch
nrpe_plugin "check_elasticsearch" do
  remote_file true
  source "https://raw.github.com/anchor/nagios-plugin-elasticsearch/176e392a97eedb1567ab1c0d05a2d4fce3aef3a3/check_elasticsearch"
  checksum "fde70383ac5125c3e7c368651bf7ca78b6b306c6cafaf0ac0987830d52655c17"
end
