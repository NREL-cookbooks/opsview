#
# Cookbook Name:: opsview
# Recipe:: check_diskstat
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

# http://exchange.nagios.org/directory/Plugins/Operating-Systems/Linux/Check-IO-stats-of-one-or-all-disks/details
nrpe_plugin "check_diskstat" do
  remote_file true
  source "http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=2778&cf_id=24"
  checksum "b2d917c17dc8d3911042463342e21faecc870fb2325530ff2f99afff201ec6c5"
end

# check_all_diskstat expects to find check_diskstat at this location, so
# symlink it into place.
link "/usr/local/nagios/libexec/check_diskstat.sh" do
  to "/usr/local/nagios/libexec/nrpe_local/check_diskstat"
end

nrpe_plugin "check_all_diskstat" do
  remote_file true
  source "http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=2778&cf_id=29"
  checksum "d2ccaef4180ca37d61a7bea89830c3efb765663bb3204eb6b6bc8c3331a8680c"
end
