#
# Cookbook Name:: opsview
# Attributes:: server
#
# Copyright 2010, NREL
#
# All rights reserved - Do Not Redistribute
#

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default[:opsview][:db][:database] = "opsview"
default[:opsview][:db][:username] = "opsview"
set_unless[:opsview][:db][:password] = secure_password

default[:opsview][:db][:runtime][:database] = "runtime"
default[:opsview][:db][:runtime][:username] = "nagios"
set_unless[:opsview][:db][:runtime][:password] = secure_password

default[:opsview][:backup][:dir] = "/usr/local/nagios/var/backups"
default[:opsview][:backup][:retention] = 30

set_unless[:opsview][:authtkt_shared_secret] = secure_password
set_unless[:opsview][:nrd_shared_password] = secure_password
