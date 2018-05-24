#
# Cookbook Name:: opsview
# Recipe:: check_postgres
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "database::postgresql"

# https://github.com/bucardo/check_postgres
nrpe_plugin "check_postgres" do
  remote_file true
  source "https://raw.githubusercontent.com/bucardo/check_postgres/2.23.0/check_postgres.pl"
  checksum "c313620516ec3ed9956b13c02a028a55dcd909591698a10ee23629a6b386de50"
end

node[:opsview][:check_postgres][:connections].each do |connection|
  postgresql_database_user("nagios") do
    connection(connection)
    # Setup the nagios user as a password-less local-only user account. This
    # means things have to go through nrpe.
    password nil
  end
end
