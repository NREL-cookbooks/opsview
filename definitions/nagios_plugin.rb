#
# Cookbook Name:: opsview
# Recipe:: nagios_plugin
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

define :nagios_plugin, :enable => true do
  if params[:enable]
    cookbook_file "/usr/local/nagios/libexec/#{params[:name]}" do
      if(params[:source])
        source params[:source]
      else
        source "nagios_plugins/#{params[:name]}"
      end
      mode "0755"
      owner "nagios"
      group "nagios"
    end
  else
    file "/usr/local/nagios/libexec/#{params[:name]}" do
      action :delete
    end

    file "/usr/local/nagios/etc/#{params[:name]}.cfg" do
      action :delete
    end
  end
end

define :nrpe_plugin, :enable => true do
  if params[:enable]
    cookbook_file "/usr/local/nagios/libexec/nrpe_local/#{params[:name]}" do
      if(params[:source])
        source params[:source]
      else
        source "nagios_plugins/#{params[:name]}"
      end
      mode "0755"
      owner "nagios"
      group "nagios"
    end

    template "/usr/local/nagios/etc/nrpe_local/#{params[:name]}.cfg" do
      source "nrpe_nagios_plugin.cfg.erb"
      variables({
        :name => params[:name],
        :env => if(params[:env]) then "env #{params[:env]} " else "" end,
      })
      mode "0440"
      owner "nagios"
      group "nagios"
      notifies :restart, "service[opsview-agent]"
    end
  else
    file "/usr/local/nagios/libexec/nrpe_local/#{params[:name]}" do
      action :delete
    end

    file "/usr/local/nagios/etc/nrpe_local/#{params[:name]}.cfg" do
      action :delete
    end
  end
end
