# Install grafana
# Get users from data bag
grafana_users=Chef::EncryptedDataBagItem.load('grafana_users','grafana_users',node['secret'])

node.default['chef-grafana']['config']['security']['admin_user'] = grafana_users['admin_name']
node.default['chef-grafana']['config']['security']['admin_password'] = grafana_users['admin_pass']

unless node['influxdb']['influx_admin']
  influx_users=data_bag_item('influx_users','influx_users', node['secret'])
  node.default['influxdb']['influx_admin']=influx_users['influx_admin']
  node.default['influxdb']['influx_admin_pass']=influx_users['influx_admin_pass']
end

# Set additional settings for grafana 
node.default['chef-grafana']['config']['server']['protocol']  = "http"
node.default['chef-grafana']['config']['server']['http_addr'] = "127.0.0.1"
node.default['chef-grafana']['config']['server']['root_url'] = "%(protocol)s://%(domain)s:%(http_port)s/grafana/"
node.default['chef-grafana']['config']['auth.proxy']['enabled'] = "true"
node.default['chef-grafana']['config']['auth.anonymous']['enabled'] = "true"


include_recipe "chef-grafana::install"
include_recipe "chef-grafana::configure"

file '/var/lib/grafana/grafana.db' do
  action :delete
end

service 'grafana-server' do
  action :restart
end

# Create data_sources
template '/tmp/data_source.sh' do
  source 'data_source.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# Import additional dashboards
template '/tmp/grafana_dashboard_import.sh' do
  source 'grafana_dashboard_import.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# Uploading dashboards
[ 
  "jmeter_load_test.json",
  "jmeter_compare_results.json",
  "security_test.json",
  "target_host_stat.json"
].each do |dashboard|
  cookbook_file dashboard do
    path "/tmp/#{dashboard}"
    owner 'root'
    group 'root'
    mode '0644'
  end
end

template "/tmp/system_stat.json" do
  source 'grafana_home_dashboard.json.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

execute "add datasource" do
  command "sh /tmp/data_source.sh"
end

execute "add dashboard" do
  command "cd /tmp && ./grafana_dashboard_import.sh"
end


