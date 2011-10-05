#
# Cookbook Name:: opsview
# Recipe:: client
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "iptables::nrpe"
include_recipe "yum::epel"

# Make sure PERL5LIB is setup properly for all users, including the "nagios"
# user things get executed as via NRPE. Otherwise, perl plugins that get run
# via NRPE can't find the Nagios::Plugin module.
template "/etc/profile.d/opsview.sh" do
  source "profile.erb"
  mode "0644"
  owner "root"
  group "root"
end

# Only run this recipe if opsview::server isn't enabled (it's RPMS install it's
# own agent that conflicts with the standalone agent.
#
# Check for the opsview::server recipe in both the expanded recipe list and the
# seen recipes list.
if(node[:recipes].include?("opsview::server") || node.recipe?("opsview::server") )
  Chef::Log.info("Skipping opsview::client recipe because conflicting opsview::server recipe is enabled")
else
  include_recipe "yum::opsview"

  # Seems to be a missing dependency, at least under RHEL6.
  if platform?("redhat", "centos", "fedora")
    package "redhat-lsb"
  end

  # FIXME: The RPM install should create this required user and group. See if
  # that works when RHEL6 official packages are released.
  #group "nagios"
  #user "nagios" do
  #  shell "/bin/bash"
  #  system true
  #  gid "nagios"
  #  home "/var/log/nagios"
  #end

  # FIXME: Use yum package when they officially support RHEL6.
  package "opsview-agent" do
    action :upgrade
    notifies :restart, "service[opsview-agent]"
  end

  service "opsview-agent" do
    supports :restart => true
    action [:enable, :start]
  end
end
