#
# Cookbook Name:: opsview
# Recipe:: check_php_fpm
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

package "perl-Time-HiRes"

nrpe_plugin "check_phpfpm_status" do
  source "nagios_plugins/check_phpfpm_status/check_phpfpm_status.pl"
end
