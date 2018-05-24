#
# Cookbook Name:: opsview
# Attributes:: server
#
# Copyright 2010, NREL
#
# All rights reserved - Do Not Redistribute
#

::Chef::Node.send(:include, OpenSSLCookbook::RandomPassword)

default[:opsview][:db][:database] = "opsview"
default[:opsview][:db][:username] = "opsview"
normal_unless[:opsview][:db][:password] = random_password

default[:opsview][:db][:runtime][:database] = "runtime"
default[:opsview][:db][:runtime][:username] = "nagios"
normal_unless[:opsview][:db][:runtime][:password] = random_password

default[:opsview][:backup][:dir] = "/usr/local/nagios/var/backups"
default[:opsview][:backup][:retention] = 30

normal_unless[:opsview][:authtkt_shared_secret] = random_password
normal_unless[:opsview][:nrd_shared_password] = random_password
