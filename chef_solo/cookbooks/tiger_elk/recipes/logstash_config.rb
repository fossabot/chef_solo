template node['tiger_elk']['logstash_config_path'] do
  source 'logstash_config.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

service 'logstash' do
  action :restart
end
