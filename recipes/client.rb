#
# Cookbook Name:: opsview
# Recipe:: client
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

# FIXME: Use opsview repo when they officially support RHEL6.
#include_recipe "yum::opsview"

# FIXME
if platform?("redhat", "centos", "fedora")
end

# Seems to be a missing dependency, at least under RHEL6.
#
# FIXME: Check to see if this is included whenever Opsview officially supports
# RHEL6.
if platform?("redhat", "centos", "fedora")
  package "openssl098e"
  package "redhat-lsb"
end

cookbook_file "#{Chef::Config[:file_cache_path]}/opsview-agent-3.11.2.6057-1.el6.x86_64.rpm" do
  source "rhel6/opsview-agent-3.11.2.6057-1.el6.x86_64.rpm"
  backup false
end

package "opsview-agent" do
  source "#{Chef::Config[:file_cache_path]}/opsview-agent-3.11.2.6057-1.el6.x86_64.rpm"
  options "--nogpgcheck" 
end

# FIXME: The RPM install should create this required user and group. See if
# that works when RHEL6 official packages are released.
group "nagios"
user "nagios" do
  shell "/bin/bash"
  system true
  gid "nagios"
  home "/var/log/nagios"
end


# FIXME: Use yum package when they officially support RHEL6.
#package "opsview-agent"

service "opsview-agent" do
  supports :restart => true
  action [:enable, :start]
end
