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
  source "https://raw.github.com/bucardo/check_postgres/5f7e574ae0a23022bd893636c655305b60e9cd55/check_postgres.pl"
  checksum "661ab885d28452d35e4d41a5f11f703300f47a085f842f0cd3fb16591ff9f0ae"
end
