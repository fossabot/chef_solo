#
# Cookbook:: tiger_elk
# Recipe:: default
#

include_recipe "tiger_elk::filebeat_install"
include_recipe "tiger_elk::elasticsearch_install"
include_recipe "tiger_elk::logstash_install"
include_recipe "tiger_elk::logstash_config"
include_recipe 'tiger_elk::kibana_install'
include_recipe 'tiger_elk::kibana_config'


