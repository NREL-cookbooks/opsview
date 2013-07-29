#
# Cookbook Name:: opsview
# Recipe:: check_php_fpm
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

package "perl-Time-HiRes"

# https://github.com/regilero/check_phpfpm_status
nrpe_plugin "check_phpfpm_status" do
  remote_file true
  source "https://raw.github.com/regilero/check_phpfpm_status/0b08d19b8109141de1d552c3e1115fbba047f265/check_phpfpm_status.pl"
  checksum "0800d96d3edb49e89d3dd79809559485ee4b02ea00c46995e00ffe9eb0e35406"
end
