#
# Cookbook Name:: opsview
# Recipe:: check_ro_mounts
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
include_recipe "perl"

package "perl-Time-HiRes"

# http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/check_ro_mounts/details
nrpe_plugin "check_ro_mounts" do
  remote_file true
  source "http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=3448&cf_id=24"
  checksum "78f560277ef7d430ef8cd6f72f11d398856a14d164ee1554d92303205a90fbdc"
end

# Fix so the plugin can find utils.pm from the Opsview lib directory.
ruby_block "opsview-check_ro_mounts-fix-lib-dir" do
  block do
    file = Chef::Util::FileEdit.new("/usr/local/nagios/libexec/nrpe_local/check_ro_mounts")
    file.search_file_replace_line(%r{^use lib "/usr/lib/nagios/plugins}, 'use lib "/usr/local/nagios/libexec";')
    file.write_file
  end
  not_if "grep 'use lib \"/usr/local/nagios/libexec\"' /usr/local/nagios/libexec/nrpe_local/check_ro_mounts"
end

