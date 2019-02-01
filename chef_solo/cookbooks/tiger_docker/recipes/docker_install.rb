
if ( node['platform_family'] == 'debian' )
  

  # Update the system
  apt_update
  package 'libltdl7'

  # Download deb-package for docker installation
  remote_file 'Download docker deb' do
    path "/tmp/#{node['tiger_docker']['docker_pkg']}"
    source node['tiger_docker']['docker_URL']
    owner 'root'
    group 'root'
    mode  '0755'
    action :create_if_missing
    not_if { File.exist?('/usr/bin/docker')}
    notifies :install, "dpkg_package[Install deb package]", :immediately
  end

  # Install docker wia previous deb-package
  dpkg_package "Install deb package" do
    action :nothing
    source "/tmp/#{node['tiger_docker']['docker_pkg']}"
    notifies :delete, "file[delete deb package]", :delayed
  end

  # Create Tiger config for docker
  template '/etc/docker/daemon.json' do
    source 'docker_daemon.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end

  # Create folder for docker containers
  directory node['tiger_docker']['docker_registry_path'] do
    mode 0644
    owner 'root'
    group 'root'
    recursive true
    action :create      
  end
  

  # Clean up the system 
  file "delete deb package" do
    path "/tmp/#{node['tiger_docker']['docker_pkg']}"
    action :nothing
  end

  service 'docker' do 
    action :restart
  end
elsif ( node['platform_family'] == 'rhel' )

	#package %w(epel-release docker-io)
  execute 'install Docker 1.7.1' do
    command 'yum install -y https://get.docker.com/rpm/1.7.1/centos-6/RPMS/x86_64/docker-engine-1.7.1-1.el6.x86_64.rpm'
    action :run
    not_if { File.exist?('/usr/bin/docker')}
  end

  # Create Tiger config for docker
  template '/etc/sysconfig/docker' do
    source 'docker_rhel.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end

  # Create folder for docker containers
  directory node['tiger_docker']['docker_registry_path'] do
    mode 0644
    owner 'root'
    group 'root'
    recursive true
    action :create      
  end

  service 'docker' do 
	action :restart
  end
end