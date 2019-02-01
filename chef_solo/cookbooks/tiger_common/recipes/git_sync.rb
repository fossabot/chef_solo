log "Creating #{node['tiger_common']['sec_tests_settings_path']}"
[
  node['tiger_common']['sec_tests_settings_path']
].each do |dir_name|
  directory dir_name do
    action :create
    recursive true
  end
end

cookbook_file '/home/tiger/.ssh/known_hosts' do
  source 'known_hosts'
  owner 'tiger'
  group 'tiger'
  mode '0755'
  action :create
end

execute "Changing #{node['tiger_common']['sec_tests_settings_path']} permissions" do
  command "chown -R tiger #{node['tiger_common']['sec_tests_settings_path']}"
end

git node['tiger_common']['sec_tests_settings_path'] do
  revision 'master'
  repository node['tiger_common']['sec_tests_settings_git_path']
#  ssh_wrapper "ssh -i /home/tiger/.ssh/id_rsa"
  user "tiger"
  action :sync
end


