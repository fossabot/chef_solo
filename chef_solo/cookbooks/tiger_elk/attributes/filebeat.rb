# ==== Install settings =====
default['tiger_elk']['filebeat_version'] = '6.0.0'
default['tiger_elk']['filebeat_deb_url'] = "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-#{node['tiger_elk']['filebeat_version']}-amd64.deb"
default['tiger_elk']['filebeat_rpm_url'] = "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-#{node['tiger_elk']['filebeat_version']}-x86_64.rpm"
