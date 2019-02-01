package %w(default-jdk git gradle python-pip) do 
  action :upgrade
end

execute "Install pip libs" do
  command <<-EOH
  	pip install requests
  	pip install slackclient
  EOH
end

[
  "#{ node['tiger_common']['software_path'] }/burp",
  "#{ node['tiger_common']['software_path'] }/burpa"
].each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    recursive true
  end
end

git "#{ node['tiger_common']['software_path'] }/burpa" do
  repository node['tiger_common']['burpa_git_repo']
  revision 'master'
  action :sync
end

git "#{ node['tiger_common']['software_path'] }/burp" do
  repository node['tiger_common']['burp_rest_git_repo']
  revision 'master'
  action :sync
end

directory "#{ node['tiger_common']['software_path'] }/burp/lib" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

# Download BURP jar
remote_file "#{ node['tiger_common']['software_path'] }/burp/lib/burpsuite_free.jar" do
  source node['tiger_common']['burp_URL']
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'build burp-rest-api jar' do
  cwd "#{ node['tiger_common']['software_path'] }/burp"
#  command './gradlew clean build'
  command "./gradlew bootRun \"-Dburp.edition=free\""
#  ignore_failure true
end
