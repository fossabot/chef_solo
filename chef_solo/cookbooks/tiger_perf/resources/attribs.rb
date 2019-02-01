property :script_type, String, name_property: true

action :create do
  require 'yaml'

  Chef::Log.info "Full sol name: #{node['tiger_perf']['full_sol_name']}"
    node.default['tiger_perf']['main_yml_path']=[
    node['tiger_perf']['perf_tests_settings_path'],
    node['tiger_perf']['full_sol_name'],
    node['tiger_perf']['env_type'],
    'config',
    "main.yml"
  ].join('/')

node.default['tiger_perf']['data_files']=[
  node['tiger_perf']['perf_tests_settings_path'],
  node['tiger_perf']['full_sol_name'],
  node['tiger_perf']['env_type'],
  'data'
  ].join('/')

node.default['tiger_perf']['env_type_path']=[
    node['tiger_perf']['perf_tests_settings_path'],
    node['tiger_perf']['full_sol_name'],
    node['tiger_perf']['env_type']
#    new_resource.script_type,
#    'config'
  ].join('/')

  # Read yml config file for getting Target_host and target_port for report
  node.default['tiger_perf']['test_details'] = YAML.load_file("#{node['tiger_perf']['env_type_path']}/config/jmeter/#{node["tiger_perf"]["tests_type"]}.yml")

  Chef::Log.info "YAML path: #{node['tiger_perf']['yaml_path']}"
  yml_content=YAML.load_file(node['tiger_perf']['main_yml_path'])
  Chef::Log.info yml_content


  if (node['tiger_perf']['test_details']['jmeter']['cmd_options']['target_host']) && (node['tiger_perf']['target_host']=='') # if targte_host defined in YML only - set tiger_perf attribute for reporting
    node.default['tiger_perf']['target_host']=node['tiger_perf']['test_details']['jmeter']['cmd_options']['target_host']
  end

  if (node['tiger_perf']['test_details']['jmeter']['cmd_options']['target_port']) && (node['tiger_perf']['target_port']=='') # if targte_host defined in YML only - set tiger_perf attribute for reporting
    node.default['tiger_perf']['target_port']=node['tiger_perf']['test_details']['jmeter']['cmd_options']['target_port']
  end


  # Per-project Influx DB setup
  if (node['tiger_common'][node['tiger_perf']['project_id'].downcase])
    node.default['tiger_perf']['influxdb_protocol'] = node['tiger_common'][node['tiger_perf']['project_id'].downcase]['influxdb_protocol']
    node.default['tiger_perf']['influx_host'] = node['tiger_perf']['rest_api_server'] # node['tiger_common'][node['tiger_perf']['project_id'].downcase]['influx_host']
    Chef::Log.info "Influx DB host: #{node['tiger_perf']['influx_host']}"
    node.default['tiger_perf']['influx_port'] = node['tiger_common'][node['tiger_perf']['project_id'].downcase]['influx_port']
    node.default['tiger_perf']['influx_db']   = node['tiger_common'][node['tiger_perf']['project_id'].downcase]['influx_db']
  else # applying default Influx DB settings in case of the per-project settings absence
    node.default['tiger_perf']['influxdb_protocol'] = node['tiger_common']['tiger']['influxdb_protocol']
    node.default['tiger_perf']['influx_host'] = node['tiger_perf']['influx_host'] #node['tiger_perf']['rest_api_server'] 
    Chef::Log.info "Influx DB host: #{node['tiger_perf']['influx_host']}"
    node.default['tiger_perf']['influx_port'] = node['tiger_common']['tiger']['influx_port']
    node.default['tiger_perf']['influx_db']   = node['tiger_common']['tiger']['influx_db']
  end


end

