
default['tiger_sec']['sec_tests_settings_path']='/opt/tiger/security/tests_settings'
default['tiger_sec']['results_path']='/opt/tiger/web/site/results/security'
default['tiger_sec']['scripts_path']='/opt/tiger/security/scripts'
default['tiger_sec']['vpn_files_path']="#{node['tiger_sec']['scripts_path']}/vpn"
default['tiger_sec']['debs_path']='/opt/tiger/security/debs'

### Burp settings ###
#default['tiger_sec']['burp_jar_file_name']='burpsuite_pro_v1.7.32.jar'
default['tiger_sec']['burp_rest_api_jar_path'] = '/opt/tiger/software/burp-rest-api/build/libs/burp-rest-api-1.0.3.jar'
default['tiger_sec']['burpa_path'] = '/opt/tiger/software/burpa'
default['tiger_sec']['burp_jar_path'] = '/opt/tiger/software/burp-rest-api/lib/burpsuite_pro.jar'
default['tiger_sec']['burp_plugins_path'] = '/opt/tiger/software/burp-rest-api/plugins'

### Qualys settings ###
default['tiger_sec']['qualys_xml'] = '/opt/tiger/security/qualys'
default['tiger_sec']['qualys_api'] = 'https://qualysapi.qualys.eu/qps/rest/3.0'
