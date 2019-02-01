
if ( node['platform_family'] == 'debian' )

  package_path = "/tmp/" + node['tiger_elk']['filebeat_deb_url'].split('/').last

  remote_file package_path do
    source node['tiger_elk']['filebeat_deb_url']
    mode '0755'
    not_if { File.exist?(package_path) }
  end

  dpkg_package package_path do
    action :install
    notifies :delete, 'file[clean_up]', :delayed
  end

  file 'clean_up' do
    path package_path
    action :nothing
  end
  

elsif ( node['platform_family'] == 'rhel' )

  package_path = "/tmp/" + node['tiger_elk']['filebeat_rpm_url'].split('/').last

  remote_file package_path do
    source node['tiger_elk']['filebeat_rpm_url']
    mode '0755'
    not_if { File.exist?(package_path) }
  end

  rpm_package package_path do
    action :install
    notifies :delete, 'file[clean_up]', :delayed
  end

  file 'clean_up' do
    path package_path
    action :nothing
  end
end

service 'filebeat' do
  action [ :enable, :restart ]
end
