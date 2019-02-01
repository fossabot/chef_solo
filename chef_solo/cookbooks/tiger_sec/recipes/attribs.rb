require 'json'

if (node['tiger_sec']['sol_ext_name'])
    node.default['tiger_sec']['full_sol_name']="#{node['tiger_sec']['project_id']}_#{node['tiger_sec']['sol_ext_name']}"
else
    node.default['tiger_sec']['full_sol_name']=node['tiger_sec']['project_id']
end

Chef::Log.info "Full sol name: #{node['tiger_sec']['full_sol_name']}"
json_path=[
  node['tiger_sec']['sec_tests_settings_path'],
  node['tiger_sec']['full_sol_name'],
  node['tiger_sec']['env_type'],
  "main",
  'config',
  "main.json"
].join('/')

Chef::Log.info "JSON path: #{json_path}"
json_content=IO.read(json_path)

begin
  json_attribs=JSON.parse(json_content)
rescue # Exception => e
  Chef::Log.fatal "Error during parsing JSON tests settings using path: #{json_path}"
  raise "Error during parsing JSON tests settings using path: #{json_path}"
end

Chef::Log.info "Tests type: #{node['tiger_sec']['tests_type']}"
Chef::Log.info "JSON path: #{json_path}"
Chef::Log.info "JSON config: #{JSON.pretty_generate(json_attribs,:indent => "  ")}"

# overriding JSON setting by cmd params
node['tiger_sec'].each do |tag_name,tag_value|
  json_attribs[node['tiger_sec']['tests_type']].each do |json_tag_name,json_tag_value|
    if (tag_name == json_tag_name && tag_value != json_tag_value)
      Chef::Log.warn "Overriding #{json_tag_name} with cmd value: #{tag_value}"
      Chef::Log.warn "target host: #{node['tiger_sec']['target_host']}"
      json_attribs[node['tiger_sec']['tests_type']][json_tag_name]=tag_value
    end
  end
end

Chef::Log.info "Attribs: #{json_attribs[node['tiger_sec']['tests_type']]}"

json_attribs[node['tiger_sec']['tests_type']].each do |json_tag_name,json_tag_value|
  node.default['tiger_sec'][json_tag_name]=json_tag_value
end

Chef::Log.info "VPN ID from attribs: #{node['tiger_sec']['vpn_id']}"
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


