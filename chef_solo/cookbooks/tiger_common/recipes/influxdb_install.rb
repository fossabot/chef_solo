# Get users from data bag
influx_users=data_bag_item('influx_users','influx_users', node['secret'])
node.default['influxdb']['influx_admin']=influx_users['influx_admin']
node.default['influxdb']['influx_admin_pass']=influx_users['influx_admin_pass']
node.default['influxdb']['influx_user']      = influx_users['influx_user']
node.default['influxdb']['influx_user_pass'] = influx_users['influx_user_pass']

# Install inluxdb
include_recipe "influxdb::default"

# Create databases
node['tiger_common']['influxdb']['databases'].each do |database|
  edit_resource(:influxdb_database, database) do
    name database
    action :create
  end
end

#Create admin user
edit_resource(:influxdb_admin, "admin") do
  username influx_users['influx_admin']
  password influx_users['influx_admin_pass']
  action :create
end
# Create user
edit_resource(:influxdb_user, 'user') do
  username influx_users['influx_user']
  password influx_users['influx_user_pass']
  databases ['collectd']
  action :create
end

# Rwrite InfluxDB config File
template node['influxdb']['config_file_path'] do
  source 'influxdb.config.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'influxdb' do
  action :restart
end

include_recipe "influxdb::client"   




