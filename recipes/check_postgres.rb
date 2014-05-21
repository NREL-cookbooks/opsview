#
# Cookbook Name:: opsview
# Recipe:: check_postgres
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

# https://github.com/bucardo/check_postgres
nrpe_plugin "check_postgres" do
  remote_file true
  source "https://github.com/bucardo/check_postgres/raw/2.21.0/check_postgres.pl"
  checksum "6693aed935835e7eaeab0a96fe810f04e15096026110d942f37a0ecbb2504df7"
end

node[:opsview][:check_postgres][:connections].each do |connection|
  postgresql_database_user("nagios") do
    connection(connection)
    # Setup the nagios user as a password-less local-only user account. This
    # means things have to go through nrpe.
    password nil
  end
end
