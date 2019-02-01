# Update system and install sofware
if ( node['platform_family'] == 'debian' )
  apt_update 'update'
  package %w(git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs) do
    action :upgrade
  end  
elsif ( node['platform_family'] == 'rhel' )
  execute 'Update System' do
    command 'yum upgrade -y; yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm'
    not_if { File.exist?('/etc/yum.repos.d/epel.repo')}
  end
  
  package %w( gcc git make automake autoconf curl-devel readline-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel nodejs) do
    action :upgrade
  end
end

directory node['tiger_common']['software_path'] do
  mode 0755
  owner 'tiger'
  group 'root'
  recursive true
  action :create      
end

directory '/opt/tiger/conf' do
  mode 0755
  owner 'tiger'
  group 'root'
  recursive true
  action :create      
end

{
"#{node['tiger_common']['software_path']}/ruby-build" => node['tiger_rest']['ruby_build_git_path'],
"#{node['tiger_common']['software_path']}/rbenv" => node['tiger_rest']['ruby_rbenv_git_path']
}.each do |fs_path,git_path|
  git fs_path do
    repository git_path
    action :sync
  end
end

log 'installing ruby'
[
  "cd #{node['tiger_common']['software_path']}/ruby-build && ./install.sh",
  "ruby-build #{node['tiger_rest']['ruby_version']} /usr/local"
].each do |cmd|
 execute "Executing #{cmd}" do
    command cmd
  end
end

gem_package "bundler" do
  action :install
  gem_binary '/usr/local/bin/gem'
end

gem_package "rails" do
  action :install
  gem_binary '/usr/local/bin/gem'
  version '5.0.1'
end


