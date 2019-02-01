

[
  node['tiger_common']['scripts_path'],
  node['tiger_common']['security_scripts_path'],
  node['tiger_common']['results_path']
].each do |dir_name|
  Chef::Log.info "Creating dir: #{dir_name}"
  directory dir_name do
    action :create
    recursive true
  end
end

log "Setting up timezone and installing common software"
[
#  "timedatectl set-timezone UTC",
  "apt-get update",
  "apt-get install -y ntp telnet python-pip python2.7-dev curl libcurl3 libcurl4-openssl-dev python-openssl at openvpn"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd
  end
end

remote_directory node['tiger_common']['gems_path'] do
  source 'ruby_gems'
  action :create
end

log "Installing ruby and Gems"
[
  "apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev",
  "cd #{node['tiger_common']['software_path']}/ruby-build && ./install.sh",
  "ruby-build -v #{node['tiger_common']['ruby_version']} /usr/local",
  "cd #{node['tiger_common']['gems_path']} && /usr/local/bin/gem install --force --local *.gem"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd
  end
end
