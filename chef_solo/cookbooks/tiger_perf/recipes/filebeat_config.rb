template node['tiger_perf']['filebeat_config_path'] do
  source 'filebeat_config.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

