# Install Java
package %w(default-jdk git) do 
  action :upgrade
end

log "Installing ruby and Gems"
[
 "/usr/local/bin/gem install builder",
 "/usr/local/bin/gem install influxdb"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd
  end
end

log "Creating /opt/tiger/software/jmeter"
[
  "/opt/tiger/software/jmeter"
].each do |dir_name|
  directory dir_name do
    action :create
    recursive true
  end
end

# Download jmeter 5.0
remote_file '/opt/tiger/software/jmeter/5.0.zip' do
  source 'https://github.com/lestatk0/jmeter5/raw/master/5.0.zip'
  mode '0755'
  action :create
end

{
  '/opt/tiger/software/jmeter/3.2.zip'=>'jmeter/3.2.zip',
  '/opt/tiger/software/jmeter/3.3.zip'=>'jmeter/3.3.zip'
}.each do |file_path,file_source|
  cookbook_file file_path do
    source file_source
    action :create
  end
end

[
  "cd /opt/tiger/software/jmeter && unzip /opt/tiger/software/jmeter/5.0.zip",
  "chmod +x /opt/tiger/software/jmeter/5.0/bin/jmeter",
  "cd /opt/tiger/software/jmeter && unzip /opt/tiger/software/jmeter/3.2.zip",
  "chmod +x /opt/tiger/software/jmeter/3.2/bin/jmeter",
  "cd /opt/tiger/software/jmeter && unzip /opt/tiger/software/jmeter/3.3.zip",
  "chmod +x /opt/tiger/software/jmeter/3.3/bin/jmeter",
# installing chrome
  "apt-get update && apt-get install -y xvfb",
  "curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb",
  "gdebi -n google-chrome-stable_current_amd64.deb"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd # nassl"
    retries 3
  end
end

# Delete all zip archives of Jmeter 
Dir["/opt/tiger/software/jmeter/*.zip"].each do |path|
  file path do
    action :delete
  end
end


{
  '/opt/tiger/software/jmeter/3.2/bin/chromedriver' => 'jmeter/webdriver/chromedriver',
  '/opt/tiger/software/jmeter/3.3/bin/chromedriver' => 'jmeter/webdriver/chromedriver'
}.each do |file_path,file_source|
  cookbook_file file_path do
    source file_source
    action :create
  end
end

[
  "chmod +x /opt/tiger/software/jmeter/3.2/bin/chromedriver",
  "chmod +x /opt/tiger/software/jmeter/3.3/bin/chromedriver"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd # nassl"
    retries 3
  end
end


# Git clone CompositeBackendListener
git '/tmp/CompositeBackendListener/' do
  repository 'https://github.com/vvxxsz00/CompositeBackendListener.git'
  action :sync
end

