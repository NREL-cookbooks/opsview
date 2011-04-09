#
# Cookbook Name:: opsview
# Recipe:: check_haproxy
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

if platform?("redhat", "centos", "fedora")
  package "perl-gettext"
else
  package "liblocale-gettext-perl"
end

nagios_plugin "check_haproxy"
