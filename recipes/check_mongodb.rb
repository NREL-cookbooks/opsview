#
# Cookbook Name:: opsview
# Recipe:: check_mongodb
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"
python_runtime "2" do
  provider :system
end

package "pymongo"

# https://github.com/mzupan/nagios-plugin-mongodb
nrpe_plugin "check_mongodb" do
  # The script must be installed with a ".py" extension or else some of its
  # internal logic fails.
  script_filename "check_mongodb.py"

  remote_file true
  source "https://raw.github.com/mzupan/nagios-plugin-mongodb/38912a82561ebe193ef0b57bd7a9fcb9d54eb009/check_mongodb.py"
  checksum "061a8f8d6edeadb1f6a48faff40fa31700634ea0a56056f8344e92b2f5f903eb"
end

# Delete the old non ".py" version if it's still around.
file "/usr/local/nagios/libexec/nrpe_local/check_mongodb" do
  action :delete
end
