default['tiger_elk']['logstash_version'] = '6.0.0'
default['tiger_elk']['logstash_rpm_url'] = "https://artifacts.elastic.co/downloads/logstash/logstash-#{node['tiger_elk']['logstash_version']}.rpm"
default['tiger_elk']['logstash_deb_url'] = "https://artifacts.elastic.co/downloads/logstash/logstash-#{node['tiger_elk']['logstash_version']}.deb"

default['tiger_elk']['logstash_config_path'] = '/etc/logstash/conf.d/tiger.conf'