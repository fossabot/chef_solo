package 'git'

# Create folders for Docker-build components
[
  node['tiger_docker']['image_path'],
  node['tiger_docker']['image_path'] + "/tests",
  node['tiger_docker']['image_path'] + "/software",
  node['tiger_docker']['image_path'] + "/jsons"
].each do |dir|
  directory dir do
    mode 0777
    owner 'root'
    group 'root'
    recursive true
    action :create      
  end
end

# Create folder for TIGER repo
directory "#{node['tiger_docker']['image_path']}/epm-tigr" do
  mode 0755
  owner 'tiger'
  group 'tiger'
  recursive true
  action :create      
end

# Set default IP for collectd client inside docker image
ruby_block "test" do
 block do
  Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut) 
  command="ip addr | grep -e inet.*docker | cut -d' ' -f 6 | awk -F'/' '{print $1}'"
  command_output = shell_out(command)
  node.default['default_host_ip'] = command_output.stdout.rstrip
 end
end 

# Create Dockerfile and run_test
{
  'Dockerfile.erb'         => "#{node['tiger_docker']['image_path']}/Dockerfile",
  'run_tiger_tests.rb.erb' => "#{node['tiger_docker']['image_path']}/tests/run_tiger_tests.rb",
  'run_tiger_tests_dev.rb.erb' => "#{node['tiger_docker']['image_path']}/tests/run_tiger_tests_dev.rb",
  'docker_image.json.erb'  => "#{node['tiger_docker']['image_path']}/jsons/docker_image.json"
}.each do |template_name,file_path|
  template file_path do
    source template_name
    action :create
  end
end

# Download additional soft tools
node['tiger_docker']['ext_git_repos'].each do |tool_name,git_link|
  git "#{node['tiger_docker']['image_path']}/software/#{tool_name}" do
    repository git_link
    action :sync
    retries 3
    timeout 3600
  end
end

# create ssh config for cloning TIGER repo
cookbook_file "/home/tiger/.ssh/config" do
  source 'config'
  owner 'tiger'
  action :create
end

# Git clone TIGER repo
git "#{node['tiger_docker']['image_path']}/epm-tigr" do
  repository node['tiger_docker']['tiger_repo']
  revision node['tiger_docker']['tiger_repo_branch']
  user "tiger"
  action :sync
end

# Build PROD image 
execute "build PROD image" do
  cwd node['tiger_docker']['image_path']
  command <<-EOF
    #!/bin/bash
    if [ -z "$(docker images -q #{node['tiger_docker']['image_name']} 2> /dev/null)" ]; then
      docker build -t #{node['tiger_docker']['image_name']} .
    else
      docker stop $(docker ps -a --filter ancestor=#{node['tiger_docker']['image_name']} --quiet)
      docker rm $(docker ps -a --filter ancestor=#{node['tiger_docker']['image_name']} --quiet) 
      docker rmi #{node['tiger_docker']['image_name']}
      docker build -t #{node['tiger_docker']['image_name']} .
    fi
  EOF
  timeout 7200
end

service 'docker' do 
  action :restart
end