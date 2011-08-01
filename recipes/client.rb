#
# Cookbook Name:: opsview
# Recipe:: client
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

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
  #
  # FIXME: Check to see if this is included whenever Opsview officially supports
  # RHEL6.
  #if platform?("redhat", "centos", "fedora")
  #  include_recipe "yum::epel"
  #
  #  package "libmcrypt"
  #  package "openssl098e"
  #  package "redhat-lsb"
  #end

  # FIXME: The RPM install should create this required user and group. See if
  # that works when RHEL6 official packages are released.
  #group "nagios"
  #user "nagios" do
  #  shell "/bin/bash"
  #  system true
  #  gid "nagios"
  #  home "/var/log/nagios"
  #end

  # FIXME? The Opsview Server RPM seems to properly setup the shell environment
  # for the opsview agent. However, the actual agent RPM doesn't. We need to
  # modify the bashrc file so that the PERL5LIB variable gets properly setup.
  # Otherwise perl plugins that get run via NRPE can't find the Nagios::Plugin
  # module.
  #template "/var/log/nagios/.bashrc" do
  #  source "agent-bashrc.erb"
  #  owner "nagios"
  #  group "nagios"
  #  mode "0644"
  #  notifies :restart, "service[opsview-agent]"
  #end

  #template "/var/log/nagios/.bash_profile" do
  #  source "agent-bash_profile.erb"
  #  owner "nagios"
  #  group "nagios"
  #  mode "0644"
  #  notifies :restart, "service[opsview-agent]"
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
