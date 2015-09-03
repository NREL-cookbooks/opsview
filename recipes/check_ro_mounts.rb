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
          https://exchange.nagios.org/components/com_mtree/attachment.php?link_id=3448&cf_id=24

  checksum "4b5d10a2ac1b8f46a57b99c3644233c6e3242bb27010f77c61c0a0bc269c834d"
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

