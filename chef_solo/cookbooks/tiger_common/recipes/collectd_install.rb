if ( node['platform_family'] == 'rhel' )
  cookbook_file '/tmp/collectd_install.sh' do
    source 'collectd_rh_install.sh'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  execute 'collectd installation' do
    command '/tmp/collectd_install.sh'
    timeout 7200
  end
else
  package 'collectd' do
    action :install
    timeout 7200
  end
end

template "#{ node['tiger_common']['collectd_conf_path'] }" do
  source 'collectd.conf.erb'
  owner  'root'
  group  'root'
  mode   '0755'
end

service 'collectd' do
  action [ :enable, :restart ]
end