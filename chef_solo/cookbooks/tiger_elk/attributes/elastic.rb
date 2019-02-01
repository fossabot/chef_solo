default['tiger_elk']['elastic_version'] = '6.0.1'
default['tiger_elk']['elastic_rpm_url'] = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{node['tiger_elk']['elastic_version']}.rpm"
default['tiger_elk']['elastic_deb_url'] = "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{node['tiger_elk']['elastic_version']}.deb"

default['tiger_elk']['elastic_config_path'] = '/etc/elasticsearch/elasticsearch.yml'