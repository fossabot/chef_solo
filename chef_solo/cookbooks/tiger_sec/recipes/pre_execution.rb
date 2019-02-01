
require 'pathname'

cookbook_file '/home/tiger/.ssh/ssh_wrapper.sh' do
  source 'ssh_wrapper.sh'
  owner 'tiger'
  mode '0770'
end

if (node['tiger_sec']['sol_ext_name'])
  node.default['tiger_sec']['full_sol_name']="#{node['tiger_sec']['project_id']}_#{node['tiger_sec']['sol_ext_name']}"
else
  node.default['tiger_sec']['full_sol_name']=node['tiger_sec']['project_id']
end


execute "Changing #{node['tiger_sec']['sec_tests_settings_path']} permissions" do
  command "chown -R tiger #{node['tiger_sec']['sec_tests_settings_path']}"
end

# Repo with security settings
Chef::Log.warn "Repo name :   Branch: #{node['tiger_sec']['tiger_env_type']}"
node.default['tiger_sec']['sec_tests_settings_git_path'] = ""


Chef::Log.warn "TIGER #{node['tiger_sec']['tiger_env_type']} environment has been specified."
if (node['tiger_sec']['tiger_env_type']=='prod')
  git node['tiger_sec']['sec_tests_settings_path'] do
    revision 'master'
    repository node['tiger_sec']['sec_tests_settings_git_path']
    ssh_wrapper "/home/tiger/.ssh/ssh_wrapper.sh"
    user "tiger"
    action :sync
  end
else
  git node['tiger_sec']['sec_tests_settings_path'] do
    revision node['tiger_sec']['tiger_env_type']
    repository node['tiger_sec']['sec_tests_settings_git_path']
    ssh_wrapper "/home/tiger/.ssh/ssh_wrapper.sh"
    user "tiger"
    action :sync
  end
end

tiger_sec_attribs "main" do
  action :create
end

node.default['tiger_sec']['node_results_path']=[
  node['tiger_sec']['results_path'],
  node['tiger_sec']['full_sol_name'],
  node['tiger_sec']['build_number'],
  DateTime.parse(node['tiger_sec']['build_started']).strftime("%m%d%y_%H-%M-%S").to_s,
  node['tiger_sec']['tests_type']].join('/')

node.default['tiger_sec']['web_results_path']=[
  "https://#{node['lc_fqdn']}",
  "results",
  "security",
  node['tiger_sec']['full_sol_name'],
  node['tiger_sec']['build_number'],
  DateTime.parse(node['tiger_sec']['build_started']).strftime("%m%d%y_%H-%M-%S").to_s,
  node['tiger_sec']['tests_type']
].join('/')

node.default['tiger_sec']['node_logs_path']="#{node['tiger_sec']['node_results_path']}/logs"
node.default['tiger_sec']['lc_results_path']=Pathname.new(node['tiger_sec']['node_results_path']).parent.to_s
Chef::Log.info "Logs path: #{node['tiger_sec']['node_logs_path']}"

[
  node['tiger_sec']['sec_tests_settings_path'],
  node['tiger_sec']['results_path'],
  node['tiger_sec']['scripts_path'],
  node['tiger_sec']['node_logs_path'],
  "#{node['tiger_sec']['node_results_path']}/data"
].each do |dir_name|
  directory dir_name do
    action :create
    recursive true
  end
end



[
  "chown -R tiger #{node['tiger_sec']['sec_tests_settings_path']}",
#  "apt-get install -y openvpn",
  "chmod +w #{node['tiger_sec']['sec_tests_settings_path']}"
#  "apt-get install -y libnet-ssleay-perl"
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

ruby_block 'Reading Qualys creds' do
  block do
    qualys_user=data_bag_item('qualys_user','qualys_user', node['secret_for_influxdb'])
    node.default['tiger_sec']['qualys_login']=qualys_user['qualys_login']
    node.default['tiger_sec']['qualys_password']=qualys_user['qualys_password']
  end
  only_if { node.attribute?('secret_for_influxdb') }
end
