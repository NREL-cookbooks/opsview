include_recipe "opsview::client"

nrpe_plugin "check_external_connectivity" do
  source "nagios_plugins/check_external_connectivity"
end
