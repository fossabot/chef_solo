if ( node['platform_family'] == 'debian' )
  apt_update
  package %w( openjdk-8-jre xvfb)
elsif ( node['platform_family'] == 'rhel' ) 
  package 'java-1.8.0-openjdk'
end

package 'python-pip'

# Install zap-cli
execute 'name' do
  command 'pip install --upgrade zapcli'
end

# Create folder for ZAP
directory node['tiger_common']['software_path'] do
  action :create
  recursive true
  not_if { File.directory?(node['tiger_common']['software_path']) }
end

#Download ZAP
remote_file '/tmp/ZAP_2.7.0_Linux.tar.gz' do
  source 'https://github.com/zaproxy/zaproxy/releases/download/2.7.0/ZAP_2.7.0_Linux.tar.gz'
  mode '0755'
  action :create
end

execute 'extract ZAP' do
  command "tar xzf ZAP_2.7.0_Linux.tar.gz -C #{node['tiger_common']['software_path']}"
  cwd '/tmp'
  not_if { File.directory?("#{node['tiger_common']['software_path']}/ZAP_2.7.0") }
end

