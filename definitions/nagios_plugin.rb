#
# Cookbook Name:: opsview
# Recipe:: nagios_plugin
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

define :nagios_plugin, :enable => true, :remote_file => false do
  script_filename = params[:script_filename] || params[:name]

  if params[:enable]
    if params[:remote_file]
      remote_file "/usr/local/nagios/libexec/#{script_filename}" do
        source params[:source]
        checksum params[:checksum]
        mode "0755"
        owner "nagios"
        group "nagios"
      end
    elsif params[:cookbook_file]
      cookbook_file "/usr/local/nagios/libexec/#{script_filename}" do
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
      file "/usr/local/nagios/libexec/#{script_filename}" do
        mode "0755"
        owner "nagios"
        group "nagios"
      end
    end
  else
    file "/usr/local/nagios/libexec/#{script_filename}" do
      action :delete
    end

    file "/usr/local/nagios/etc/#{params[:name]}.cfg" do
      action :delete
    end
  end
end

define :nrpe_plugin, :enable => true, :cookbook_file => true, :remote_file => false do
  script_filename = params[:script_filename] || params[:name]
  script_path = params[:script_path] || "/usr/local/nagios/libexec/nrpe_local/#{script_filename}"

  if params[:enable]
    if params[:remote_file]
      remote_file(script_path) do
        source params[:source]
        checksum params[:checksum]
        mode "0755"
        owner "nagios"
        group "nagios"
      end
    elsif params[:cookbook_file]
      cookbook_file(script_path) do
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
      unless params[:script_path]
        file(script_path) do
          mode "0755"
          owner "nagios"
          group "nagios"
        end
      end
    end

    template "/usr/local/nagios/etc/nrpe_local/#{params[:name]}.cfg" do
      source "nrpe_nagios_plugin.cfg.erb"
      variables({
        :name => params[:name],
        :script_path => script_path,
        :sudo => if(params[:sudo]) then "sudo " else "" end,
        :env => if(params[:env]) then "env #{params[:env]} " else "" end,
      })
      mode "0440"
      owner "nagios"
      group "nagios"
      notifies :restart, "service[opsview-agent]"
    end
  else
    file "/usr/local/nagios/libexec/nrpe_local/#{script_filename}" do
      action :delete
    end

    file "/usr/local/nagios/etc/nrpe_local/#{params[:name]}.cfg" do
      action :delete
    end
  end
end
