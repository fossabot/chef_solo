
#default['tiger_common']['users_data_bag']=Chef::EncryptedDataBagItem.load("tiger_users", "tiger_users", node['user_secret'])
default['tiger_common']['software_path']='/opt/tiger/software'
default['tiger_common']['ruby_version']='2.3.3'
default['tiger_common']['gems_path']="#{node['tiger_common']['software_path']}/ruby_gems"
default['tiger_common']['scripts_path']='/opt/tiger/scripts'
default['tiger_common']['security_scripts_path']=node['tiger_common']['scripts_path']+"/security"
default['tiger_common']['chef_solo_automation_path']='/opt/tiger/chef_solo'
# default['tiger_common']['sec_tests_results_path']='/opt/tiger/tests_results/security'
default['tiger_common']['perf_tests_results_path']='/opt/tiger/tests_results/performance'

# KOSTYL'
default['tiger_common']['sec_tests_settings_path']='/opt/tiger/security/tests_settings'
default['tiger_common']['sec_tests_settings_git_path']=""
default['tiger_common']['results_path']='/opt/tiger/web/site/results/security'


