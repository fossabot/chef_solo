
require 'pathname'
require 'date'
require 'yaml'

cookbook_file '/home/tiger/.ssh/ssh_wrapper.sh' do
  source 'ssh_wrapper.sh'
  owner 'tiger'
  mode '0770'
end

# Create folder for perf logs
directory '/opt/tiger/logs' do
  owner 'tiger'
  mode '0755'
  action :create
end

if (node['tiger_perf']['sol_ext_name'])
  node.default['tiger_perf']['full_sol_name']="#{node['tiger_perf']['project_id']}_#{node['tiger_perf']['sol_ext_name']}"
else
  node.default['tiger_perf']['full_sol_name']=node['tiger_perf']['project_id']
end


execute "Changing #{node['tiger_perf']['perf_tests_settings_path']} permissions" do
  command "mkdir -p #{node['tiger_perf']['perf_tests_settings_path']} && chown -R tiger #{node['tiger_perf']['perf_tests_settings_path']}"
end

Chef::Log.warn "TIGER #{node['tiger_perf']['tiger_env_type']} environment has been specified."
if (node['tiger_perf']['tiger_env_type']=='prod')
  git node['tiger_perf']['perf_tests_settings_path'] do
    revision 'master'
    repository node['tiger_perf']['perf_tests_settings_git_path']
    ssh_wrapper "/home/tiger/.ssh/ssh_wrapper.sh"
    user "tiger"
    action :sync
  end
else
  git node['tiger_perf']['perf_tests_settings_path'] do
    revision node['tiger_perf']['tiger_env_type']
    repository node['tiger_perf']['perf_tests_settings_git_path']
    ssh_wrapper "/home/tiger/.ssh/ssh_wrapper.sh"
    user "tiger"
    action :sync
  end
end

tiger_perf_attribs "main" do
  action :create
end

node.default['tiger_perf']['node_results_path']=[
  node['tiger_perf']['results_path'],
  node['tiger_perf']['full_sol_name'],
  node['tiger_perf']['build_number'],
  DateTime.parse(node['tiger_perf']['build_started']).strftime("%m%d%y_%H-%M-%S").to_s,
  node['container_name'],
  node['tiger_perf']['tests_type']].join('/')

node.default['tiger_perf']['common_log_path']=[
  node['tiger_perf']['results_path'],
  node['tiger_perf']['full_sol_name'],
  node['tiger_perf']['build_number'],
  DateTime.parse(node['tiger_perf']['build_started']).strftime("%m%d%y_%H-%M-%S").to_s
].join('/')


node.default['tiger_perf']['web_results_path']=[
  "https://#{node['lc_fqdn']}",
  "results",
  "performance",
  node['tiger_perf']['full_sol_name'],
  node['tiger_perf']['build_number'],
  DateTime.parse(node['tiger_perf']['build_started']).strftime("%m%d%y_%H-%M-%S").to_s,
  node['container_name'],
  node['tiger_perf']['tests_type']
].join('/')


node.default['tiger_perf']['common_web_results_path']=[
  "https://#{node['lc_fqdn']}",
  "results",
  "performance",
  node['tiger_perf']['full_sol_name'],
  node['tiger_perf']['build_number'],
  DateTime.parse(node['tiger_perf']['build_started']).strftime("%m%d%y_%H-%M-%S").to_s,
].join('/')

node.default['tiger_perf']['web_aggregated_results_path']=[
  "https://#{node['lc_fqdn']}",
  "results",
  "performance",
  node['tiger_perf']['full_sol_name'],
  node['tiger_perf']['build_number'],
  DateTime.parse(node['tiger_perf']['build_started']).strftime("%m%d%y_%H-%M-%S").to_s,
  "aggregated",
  node['tiger_perf']['tests_type']
].join('/')

node.default['tiger_perf']['node_logs_path'] = "#{node['tiger_perf']['node_results_path']}/logs"
node.default['tiger_perf']['node_data_path'] = "#{node['tiger_perf']['node_results_path']}/data"
node.default['tiger_perf']['aggregated_results_path'] = "#{node['tiger_perf']['common_log_path']}/aggregated/#{node['tiger_perf']['tests_type']}"
node.default['tiger_perf']['lc_results_path'] = Pathname.new(node['tiger_perf']['node_results_path']).parent.to_s  
Chef::Log.info "Logs path: #{node['tiger_perf']['node_logs_path']}"

[
  node['tiger_perf']['perf_tests_settings_path'],
  node['tiger_perf']['results_path'],
  node['tiger_perf']['scripts_path'],
  node['tiger_perf']['node_logs_path'],
  node['tiger_perf']['node_data_path']
].each do |dir_name|
  directory dir_name do
    action :create
    recursive true
  end
end

# Changing folders permissions
[
  "chown -R tiger /home/tiger",
  "chown -R tiger #{node['tiger_perf']['node_logs_path']}",
  "chown -R tiger #{node['tiger_perf']['node_data_path']}"

].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd # nassl"
    retries 3
  end
end

ruby_block 'Reading INFLUXDB creds' do
  block do
    influx_users=data_bag_item('influx_users','influx_users', node['secret_for_influxdb'])
    node.default['influxdb']['influx_admin']=influx_users['influx_admin']
    node.default['influxdb']['influx_admin_pass']=influx_users['influx_admin_pass']
  end
  only_if { node.attribute?('secret_for_influxdb') }
end

include_recipe "tiger_perf::filebeat_config"
