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

  cookbook_file "#{Chef::Config[:file_cache_path]}/opsview-agent-3.11.3.6091-1.el6.#{node[:kernel][:machine]}.rpm" do
    source "rhel6/opsview-agent-3.11.3.6091-1.el6.#{node[:kernel][:machine]}.rpm"
    backup false
  end

  package "opsview-agent" do
    source "#{Chef::Config[:file_cache_path]}/opsview-agent-3.11.3.6091-1.el6.#{node[:kernel][:machine]}.rpm"
    options "--nogpgcheck" 
  end

  rpms = [
    { :package => "opsview-agent", :file => "opsview-agent-3.11.3.6091-1.el6.#{node[:kernel][:machine]}.rpm" },
  ]

  rpms.each do |rpm|
    cookbook_file "#{Chef::Config[:file_cache_path]}/#{rpm[:file]}" do
      source "rhel6/#{rpm[:file]}"
      backup false
    end

    package rpm[:package] do
      source "#{Chef::Config[:file_cache_path]}/#{rpm[:file]}"
      options "--nogpgcheck" 
    end
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
end
