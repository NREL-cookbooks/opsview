#
# Cookbook Name:: opsview
# Recipe:: check_writable
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "perl::data_random"

# http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_writable/details
remote_file "#{Chef::Config[:file_cache_path]}/check_writable-#{node[:opsview][:check_writable][:version]}.tar.gz" do
  source "https://trac.id.ethz.ch/projects/nagios_plugins/downloads/check_writable-#{node[:opsview][:check_writable][:version]}.tar.gz"
  checksum node[:opsview][:check_writable][:archive_checksum]
end

path = "/usr/local/nagios/libexec/nrpe_local/check_writable"
bash "make_check_writable" do
  cwd Chef::Config[:file_cache_path]

  code <<-EOS
  rm -rf #{Chef::Config[:file_cache_path]}/check_writable-#{node[:opsview][:check_writable][:version]}
  tar -xvf check_writable-#{node[:opsview][:check_writable][:version]}.tar.gz
  cd check_writable-#{node[:opsview][:check_writable][:version]}
  perl Makefile.PL && \
  make && \
  cp blib/script/check_writable #{path}
  EOS

  not_if do
    ::File.exists?(path) && system("#{path} --version | grep 'version #{node[:opsview][:check_writable][:version]}$'")
  end
end

nrpe_plugin "check_writable" do
  cookbook_file false
end
