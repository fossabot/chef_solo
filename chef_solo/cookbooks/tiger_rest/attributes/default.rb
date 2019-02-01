default['tiger_rest']['ruby_build_git_path']='https://github.com/sstephenson/ruby-build.git'
default['tiger_rest']['ruby_rbenv_git_path']='https://github.com/sstephenson/rbenv.git'
default['tiger_rest']['ruby_version']="2.3.3"
default['tiger_rest']['apps_path']='/opt/tiger/RoR'
default['tiger_rest']['tests_path']='/opt/tiger/tests'
default['tiger_rest']['docker_hosts_file']='/opt/tiger/docker/hosts.txt'
default['tiger_rest']['image_mount_path']="/opt/tiger"

# For JobController
default['tiger_rest']['cert_path']         = '/opt/tiger/certs'
default['tiger_rest']['prod_docker_image'] = node['tiger_docker']['image_name']
default['tiger_rest']['dev_docker_image']  = node['tiger_docker']['dev_image_name']
default['tiger_rest']['docker_test_path']  = node['tiger_docker']['image_path'] + '/tests'

# REST YAML config file
default['tiger_rest']['infrastructure_file_path']="/opt/tiger/conf"
