#
# Cookbook Name:: opsview
# Recipe:: check_haproxy
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "perl"

if platform?("redhat", "centos", "fedora")
  package "perl-gettext"
else
  package "liblocale-gettext-perl"
end

nrpe_plugin "check_haproxy" do
  enable false
end
nagios_plugin "check_haproxy"
