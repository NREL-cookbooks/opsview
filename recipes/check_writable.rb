#
# Cookbook Name:: opsview
# Recipe:: check_writable
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build-essential"
include_recipe "opsview::client"
include_recipe "perl"
include_recipe "yum-epel"

package "perl-ExtUtils-MakeMaker"
cpan_module "Monitoring::Plugin"
cpan_module "Data::Random"
cpan_module "Module::Install" do
  # cpan_module's default check to see if the module is installed doesn't
  # properly detect this module, since it requires the module be included via
  # "inc::Module::Install" instead of "Module::Install". So do a simple
  # file-based check instead to prevent repeated installs.
  not_if { ::File.exist?("/usr/local/share/perl5/Module/Install.pm") }
end

# http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_writable/details
remote_file "#{Chef::Config[:file_cache_path]}/check_writable-#{node[:opsview][:check_writable][:version]}.tar.gz" do
  source "https://github.com/matteocorti/check_writable/archive/v#{node[:opsview][:check_writable][:version]}.tar.gz"
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
