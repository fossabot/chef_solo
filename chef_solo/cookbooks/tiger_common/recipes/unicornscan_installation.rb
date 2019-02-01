package %w(libc6 flex) do
    action :upgrade
end

directory node['tiger_common']['unicornscan_path'] do
    owner 'root'
    group 'root'
    mode  '0755'
    action :create
end

cookbook_file "#{ node['tiger_common']['unicornscan_path'] }/unicornscan_0.4.7-amd64.deb" do
    source 'unicornscan_0.4.7-amd64.deb'
    owner 'root'
    group 'root'
    mode  '0755'
    action :create_if_missing
end

dpkg_package 'unicornscan_0.4.7-amd64.deb' do
    action :install
    source "#{ node['tiger_common']['unicornscan_path'] }/unicornscan_0.4.7-amd64.deb" 
    not_if { File.exist?("/usr/bin/unicornscan") }
end