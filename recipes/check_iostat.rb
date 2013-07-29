#
# Cookbook Name:: opsview
# Recipe:: check_iostat
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

package "sysstat"
package "bc"

# http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_iostat--2D-I-2FO-statistics/details
# Locally patched with patch from comments.
nrpe_plugin "check_iostat"
