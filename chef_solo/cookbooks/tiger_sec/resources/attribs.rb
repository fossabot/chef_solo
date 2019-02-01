property :script_type, String, name_property: true

action :create do
  require 'yaml'

  Chef::Log.info "Full sol name: #{node['tiger_sec']['full_sol_name']}"
  yaml_path=[
    node['tiger_sec']['sec_tests_settings_path'],
    node['tiger_sec']['full_sol_name'],
    node['tiger_sec']['env_type'],
    new_resource.script_type,
    'config',
    "#{new_resource.script_type}.yml"
  ].join('/')

  begin
    yaml_attribs=YAML.load_file(yaml_path)
  rescue # Exception => e
    Chef::Log.fatal "Error during parsing YAML tests settings using path: #{yaml_path}"
    raise "Error during parsing YAML tests settings using path: #{yaml_path}"
  end

  Chef::Log.info "Tests type: #{node['tiger_sec']['tests_type']}"
  Chef::Log.info "YAML path: #{yaml_path}"

  # overriding YAML setting by cmd params
  node['tiger_sec'].each do |tag_name,tag_value|
    yaml_attribs[node['tiger_sec']['tests_type']].each do |yaml_tag_name,yaml_tag_value|
      if (tag_name == yaml_tag_name && tag_value != yaml_tag_value)
        Chef::Log.warn "Overriding #{yaml_tag_name} with cmd value: #{tag_value}"
        Chef::Log.warn "target host: #{node['tiger_sec']['target_host']}"
        yaml_attribs[node['tiger_sec']['tests_type']][yaml_tag_name]=tag_value
      end
    end
  end

  Chef::Log.info "Attribs: #{yaml_attribs[node['tiger_sec']['tests_type']]}"

  yaml_attribs[node['tiger_sec']['tests_type']].each do |yaml_tag_name,yaml_tag_value|
    node.default['tiger_sec'][yaml_tag_name]=yaml_tag_value
  end

  # setting up certs password

  # generating vpn related files
  if (node['tiger_sec']['vpn_id'] && node['tiger_sec']['vpn_id']!='')
    Chef::Log.info ("VPN ID dump: #{node['tiger_sec']['vpn_id']}")
    tiger_sec_vpn node['tiger_sec']['vpn_id'] do
      action :create
    end
  end

  if (node['tiger_sec']['w3af_file_name'] && node['tiger_sec']['w3af_file_name']!='')
    node.default['tiger_sec']['w3af_config_path']=[
      node['tiger_sec']['sec_tests_settings_path'],
      node['tiger_sec']['full_sol_name'],
      node['tiger_sec']['env_type'],
      "w3af",
      "config",
      node['tiger_sec']['w3af_file_name']
    ].join('/')
  end

  # NMAP exclusion path
  node.default['tiger_sec']['nmap_exclusions_file_path']=[
    node['tiger_sec']['sec_tests_settings_path'],
    node['tiger_sec']['full_sol_name'],
    node['tiger_sec']['env_type'],
    "nmap",
    "exclusions",
    node["tiger_sec"]["tests_type"],
    "exclusions.yml"
  ].join('/')

  # NIKTO exclusion path
  node.default['tiger_sec']['nikto_exclusions_file_path']=[
    node['tiger_sec']['sec_tests_settings_path'],
    node['tiger_sec']['full_sol_name'],
    node['tiger_sec']['env_type'],
    "nikto",
    "exclusions",
    node["tiger_sec"]["tests_type"],
    "exclusions.yml"
  ].join('/')

  ###### BURP section ######

  # Burp exclusion path
  node.default['tiger_sec']['burp_exclusions_file_path']=[
    node['tiger_sec']['sec_tests_settings_path'],
    node['tiger_sec']['full_sol_name'],
    node['tiger_sec']['env_type'],
    "burp",
    "exclusions",
    node["tiger_sec"]["tests_type"],
    "exclusions.yml"
  ].join('/')

  node.default['tiger_sec']['burp_project_files_path']=[
    node['tiger_sec']['sec_tests_settings_path'],
    node['tiger_sec']['full_sol_name'],
    node['tiger_sec']['env_type'],
    "burp",
    "projects"
  ].join('/')

 ###### Sslyze section ######
 node.default['tiger_sec']['sslyze_exclusions_file_path']=[
    node['tiger_sec']['sec_tests_settings_path'],
    node['tiger_sec']['full_sol_name'],
    node['tiger_sec']['env_type'],
    "sslyze",
    "exclusions",
    node["tiger_sec"]["tests_type"],
    "exclusions.yml"
  ].join('/')

 ###### ZAP section ######

  # ZAP exclusion path
  node.default['tiger_sec']['zap_exclusions_file_path']=[
    node['tiger_sec']['sec_tests_settings_path'],
    node['tiger_sec']['full_sol_name'],
    node['tiger_sec']['env_type'],
    "zap",
    "exclusions",
    node["tiger_sec"]["tests_type"],
    "exclusions.yml"
  ].join('/')

  # Zap context path
  if (node['tiger_sec']['zap_user'] && node['tiger_sec']['zap_context'])
    node.default['tiger_sec']['zap_context_path']=[
      node['tiger_sec']['sec_tests_settings_path'],
      node['tiger_sec']['full_sol_name'],
      node['tiger_sec']['env_type'],
      "zap",
      "context",
      node['tiger_sec']['tests_type'] + ".context"
    ].join('/')
  end

  # Per-project Influx DB setup
  if (node['tiger_common'][node['tiger_sec']['project_id'].downcase])
    node.default['tiger_sec']['influxdb_protocol'] = node['tiger_common'][node['tiger_sec']['project_id'].downcase]['influxdb_protocol']
    node.default['tiger_sec']['influx_host'] = node['tiger_sec']['rest_api_server']
    Chef::Log.info "Influx DB host: #{node['tiger_sec']['influx_host']}"
    node.default['tiger_sec']['influx_port'] = node['tiger_common'][node['tiger_sec']['project_id'].downcase]['influx_port']
    node.default['tiger_sec']['influx_db']   = node['tiger_common'][node['tiger_sec']['project_id'].downcase]['influx_db_security']
  else # applying default Influx DB settings in case of the per-project settings absence
    node.default['tiger_sec']['influxdb_protocol'] = node['tiger_common']['tiger']['influxdb_protocol']
    node.default['tiger_sec']['influx_host'] = node['tiger_sec']['rest_api_server']
    Chef::Log.info "Influx DB host: #{node['tiger_sec']['influx_host']}"
    node.default['tiger_sec']['influx_port'] = node['tiger_common']['tiger']['influx_port']
    node.default['tiger_sec']['influx_db']   = node['tiger_common']['tiger']['influx_db_security']
  end


end
