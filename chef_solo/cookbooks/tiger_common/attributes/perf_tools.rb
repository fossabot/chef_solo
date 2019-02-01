# Attributes for Jmeter
default['tiger_common']['jmeter_path']   = node['tiger_common']['software_path']+'/jmeter'
default['tiger_common']['jmeter_source'] = 'http://ftp.byfly.by/pub/apache.org//jmeter/binaries/apache-jmeter-3.2.tgz'
default['tiger_common']['jmeter_file']   = node['tiger_common']['jmeter_source'].split('/').last


# Attributes for CollectD
if ( node['platform_family'] == 'rhel')
  default['tiger_common']['collectd_conf_path'] = '/etc/collectd.conf'
elsif (node['platform_family'] == 'debian')  
  default['tiger_common']['collectd_conf_path']   = '/etc/collectd/collectd.conf'
end  
default['tiger_common']['collectd_server_path'] = '127.0.0.1'


# Attributes for Influxdb
default['tiger_common']['influxdb']['databases'] = ['collectd','jmeter','security_tests']
# For influxdb versions >= 1.0.x
default['influxdb']['lib_file_path'] = '/var/lib/influxdb'
default['influxdb']['meta_file_path'] = "#{node['influxdb']['lib_file_path']}/meta"
default['influxdb']['data_file_path'] = "#{node['influxdb']['lib_file_path']}/data"
default['influxdb']['wal_file_path'] = "#{node['influxdb']['lib_file_path']}/wal"
default['influxdb']['ssl_cert_file_path'] = '/etc/ssl/influxdb.pem'
default['influxdb']['config_file_path'] = '/etc/influxdb/influxdb.conf'
