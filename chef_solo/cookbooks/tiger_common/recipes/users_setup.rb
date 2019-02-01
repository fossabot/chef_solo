
node.default['tiger_common']['users_data_bag']=Chef::EncryptedDataBagItem.load("tiger_users", "tiger_users", node['user_secret'])

log "Setting up internal tiger user"

directory "/home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh" do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end

user node['tiger_common']['users_data_bag']['tiger_user_name'] do
  comment 'Tiger user'
  home "/home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}"
end

if ( node['platform_family'] == 'debian' )
  [

    "echo \"#{node['tiger_common']['users_data_bag']['id_rsa_pub']}\" > /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/id_rsa.pub",
    "echo \"#{node['tiger_common']['users_data_bag']['id_rsa_pub']}\" > /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/authorized_keys",
    "echo \"#{node['tiger_common']['users_data_bag']['id_rsa']}\" > /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/id_rsa",
    "chown -R #{node['tiger_common']['users_data_bag']['tiger_user_name']} /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh",
    "chmod -R 644 /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh",
    "chmod 600 /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/id_rsa",
    "chmod 755 /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh",
    #"usermod -aG sudo #{node['tiger_common']['users_data_bag']['tiger_user_name']}",
    "echo \"tiger ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"
  ].each do |cmd|
    execute "Executing: #{cmd}" do
      command cmd
    end
  end
elsif ( node['platform_family'] == 'rhel' )

  

  group 'wheel' do
    action :modify
    members node['tiger_common']['users_data_bag']['tiger_user_name']
  end
  [
    "echo \"#{node['tiger_common']['users_data_bag']['id_rsa_pub']}\" > /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/id_rsa.pub",
    "echo \"#{node['tiger_common']['users_data_bag']['id_rsa_pub']}\" > /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/authorized_keys",
    "echo \"#{node['tiger_common']['users_data_bag']['id_rsa']}\" > /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/id_rsa",
    "chown -R #{node['tiger_common']['users_data_bag']['tiger_user_name']} /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh",
    "chmod -R 644 /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh",
    "chmod 600 /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh/id_rsa",
    "chmod 755 /home/#{node['tiger_common']['users_data_bag']['tiger_user_name']}/.ssh",
    "echo \"tiger ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"
  ].each do |cmd|
    execute "Executing: #{cmd}" do
      command cmd
    end
  end

end

