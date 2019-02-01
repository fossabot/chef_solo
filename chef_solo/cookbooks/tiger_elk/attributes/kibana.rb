default['tiger_elk']['kibana_version'] = '6.0.1'
default['tiger_elk']['kibana_deb_url'] = "https://artifacts.elastic.co/downloads/kibana/kibana-#{node['tiger_elk']['kibana_version']}-amd64.deb"
default['tiger_elk']['kibana_rpm_url'] = "https://artifacts.elastic.co/downloads/kibana/kibana-#{node['tiger_elk']['kibana_version']}-x86_64.rpm"

default['tiger_elk']['kibana_config_path'] = '/etc/kibana/kibana.yml'