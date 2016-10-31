#
# Cookbook Name:: opsview
# Recipe:: check_ro_mounts
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "perl"

package "perl-Time-HiRes"

# http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_ro_mounts/details
#
# Locally patched so the plugin can find utils.pm from the Opsview lib
# directory.
nrpe_plugin "check_ro_mounts"
