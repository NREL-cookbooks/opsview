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

# https://github.com/polymorf/check_haproxy
nagios_plugin "check_haproxy" do
  remote_file true
  source "https://raw.github.com/polymorf/check_haproxy/187fcd5c3596c8ac691be6cc8ae563289864f29a/check_haproxy.pl"
  checksum "fba38544ba4690f96b98f96a354909ef7d570386b42043dc976324eb460cc2a5"
end
