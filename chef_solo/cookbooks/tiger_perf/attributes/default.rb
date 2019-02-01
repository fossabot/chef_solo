
default['tiger_perf']['perf_tests_settings_path']='/opt/tiger/performance/tests_settings'
default['tiger_perf']['results_path']='/opt/tiger/web/site/results/performance'
default['tiger_perf']['scripts_path']='/opt/tiger/performance/scripts'
default['tiger_perf']['debs_path']='/opt/tiger/performance/debs'



# ====== Filebeat ======
default['tiger_perf']['filebeat_config_path'] = '/etc/filebeat/filebeat.yml'
default['tiger_perf']['filebeat_output_IP'] = '127.0.0.1'

# Attributes for Jmeter connection to InfluxDB
# User and Pass for connection can be viewed in tiger_common::influxdb_install
