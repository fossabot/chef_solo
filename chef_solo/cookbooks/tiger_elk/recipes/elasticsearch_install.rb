
if ( node['platform_family'] == 'debian' )

  package "openjdk-#{node['tiger_elk']['java_version']}-jre" do
    action :install
  end

  package_path = "/tmp/" + node['tiger_elk']['elastic_deb_url'].split('/').last

  remote_file package_path do
    source node['tiger_elk']['elastic_deb_url']
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

  package "java-1.#{node['tiger_elk']['java_version']}.0-openjdk" do
    action :install
  end

  package_path = "/tmp/" + node['tiger_elk']['elastic_rpm_url'].split('/').last

  remote_file package_path do
    source node['tiger_elk']['elastic_rpm_url']
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

service 'elasticsearch' do
  action [ :enable, :restart ]
end
