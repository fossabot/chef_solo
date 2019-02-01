package 'logrotate'

template "/etc/logrotate.d/tiger_ror_rotation" do
  source "logrotation_tiger_ror.erb"
  action :create
end

cron 'logrotation of tiger_rest' do
  minute '30'
  hour '0'
  command '/usr/sbin/logrotate /etc/logrotate.d/tiger_ror_rotation'
  only_if { File.exist?('/etc/logrotate.d/tiger_ror_rotation')}
end
