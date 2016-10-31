yum_repository("opsview") do
  description "Opsview"
  baseurl "https://downloads.opsview.com/opsview-core/latest/yum/rhel/$releasever/$basearch"
  enabled true
  gpgcheck false
  action :create
end
