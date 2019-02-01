template node['tiger_elk']['kibana_config_path'] do
  source 'kibana_config.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

service 'kibana' do
  action :restart
end
