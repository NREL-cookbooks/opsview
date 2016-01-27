#
# Cookbook Name:: opsview
# Recipe:: check_ssl_cert
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "perl"

# http://exchange.nagios.org/directory/Plugins/Network-Protocols/HTTP/check_ssl_cert/details
remote_file "#{Chef::Config[:file_cache_path]}/check_ssl_cert-#{node[:opsview][:check_ssl_cert][:version]}.tar.gz" do
  source "https://github.com/matteocorti/check_ssl_cert/archive/v#{node[:opsview][:check_ssl_cert][:version]}.tar.gz"
  checksum node[:opsview][:check_ssl_cert][:archive_checksum]
end

path = "/usr/local/nagios/libexec/check_ssl_cert"
bash "make_check_ssl_cert" do
  cwd Chef::Config[:file_cache_path]

  code <<-EOS
  rm -rf #{Chef::Config[:file_cache_path]}/check_ssl_cert-#{node[:opsview][:check_ssl_cert][:version]}
  tar -xvf check_ssl_cert-#{node[:opsview][:check_ssl_cert][:version]}.tar.gz
  cp check_ssl_cert-#{node[:opsview][:check_ssl_cert][:version]}/check_ssl_cert #{path}
  rm -rf #{Chef::Config[:file_cache_path]}/check_ssl_cert-#{node[:opsview][:check_ssl_cert][:version]}
  EOS

  not_if do
    ::File.exists?(path) && system("#{path} --version | grep '^check_ssl_cert version #{node[:opsview][:check_updates][:version]}$'")
  end
end

nagios_plugin "check_ssl_cert" do
  cookbook_file false
end
