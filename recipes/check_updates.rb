#
# Cookbook Name:: opsview
# Recipe:: check_updates
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build-essential"
include_recipe "opsview::client"
include_recipe "opsview::nrpe_sudo"
include_recipe "perl"
include_recipe "yum::epel"

package "perl-Module-Install"
package "perl-Readonly"
package "perl-Sort-Versions"

# http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_updates/details
remote_file "#{Chef::Config[:file_cache_path]}/check_updates-#{node[:opsview][:check_updates][:version]}.tar.gz" do
  source "https://github.com/matteocorti/check_updates/archive/v#{node[:opsview][:check_updates][:version]}.tar.gz"
  checksum node[:opsview][:check_updates][:archive_checksum]
end

path = "/usr/local/nagios/libexec/nrpe_local/check_updates"
bash "make_check_updates" do
  cwd Chef::Config[:file_cache_path]

  code <<-EOS
  rm -rf #{Chef::Config[:file_cache_path]}/check_updates-#{node[:opsview][:check_updates][:version]}
  tar -xvf check_updates-#{node[:opsview][:check_updates][:version]}.tar.gz
  cd check_updates-#{node[:opsview][:check_updates][:version]}
  perl Makefile.PL && \
  make && \
  cp blib/script/check_updates #{path}
  EOS

  not_if do
    ::File.exists?(path) && system("#{path} --version | grep '^check_updates #{node[:opsview][:check_updates][:version]} '")
  end
end

nrpe_plugin "check_updates" do
  cookbook_file false
  sudo true
end

sudo "nagios_check_updates" do
  user "nagios" 

  commands [
    "/usr/local/nagios/libexec/nrpe_local/check_updates",
  ]

  host "ALL"
  nopasswd true
end

