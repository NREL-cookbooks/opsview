#
# Cookbook Name:: opsview
# Attributes:: server
#
# Copyright 2010, NREL
#
# All rights reserved - Do Not Redistribute
#

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default[:opsview][:db][:host] = "localhost"
default[:opsview][:db][:database] = "opsview"
default[:opsview][:db][:username] = "opsview"
set_unless[:opsview][:db][:password] = secure_password

default[:opsview][:db][:runtime][:host] = "localhost"
default[:opsview][:db][:runtime][:database] = "runtime"
default[:opsview][:db][:runtime][:username] = "nagios"
set_unless[:opsview][:db][:runtime][:password] = secure_password

default[:opsview][:db][:odw][:host] = "localhost"
default[:opsview][:db][:odw][:database] = "odw"
default[:opsview][:db][:odw][:username] = "odw"
set_unless[:opsview][:db][:odw][:password] = secure_password

default[:opsview][:db][:reports][:host] = "localhost"
default[:opsview][:db][:reports][:database] = "reports"
default[:opsview][:db][:reports][:username] = "reporter"
set_unless[:opsview][:db][:reports][:password] = secure_password

default[:opsview][:backup][:dir] = "/usr/local/nagios/var/backups"
default[:opsview][:backup][:retention] = 30
