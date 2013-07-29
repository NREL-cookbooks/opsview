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

nrpe_plugin "check_iostat"
