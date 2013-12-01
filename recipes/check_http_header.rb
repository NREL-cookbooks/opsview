#
# Cookbook Name:: opsview
# Recipe:: check_php_fpm
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "opsview::client"

package "perl-WWW-Curl"

# https://github.com/svenmueller/check-http-header
nagios_plugin "check_http_header" do
  remote_file true
  source "https://raw.github.com/svenmueller/check-http-header/32f3270cbed6977125206c1bcd51c73c1553ba6b/check_http_header.pl"
  checksum "5b12b196650b5c1179daa63a4327a22ecb3449c39daee62fd605006c30662b61"
end
