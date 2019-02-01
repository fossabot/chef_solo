
git "#{node['tiger_common']['software_path']}/nikto" do
  revision 'master'
  #revision '098177b01729ae33a260ff1bc43cff3e425f7c7e'
  repository node['tiger_common']['nikto_git_path']
#  ssh_wrapper "ssh -i /home/tiger/.ssh/id_rsa"
#  user "tiger"
  action :sync
end


[
  "apt-get update",
  "apt-get install -y libnet-ssleay-perl"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd # nassl"
    retries 3
  end
end
