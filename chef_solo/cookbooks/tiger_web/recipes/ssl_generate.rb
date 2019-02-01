
  package 'openssl' do
    action :install
  end

  # Create CA key and self-sign cert
  execute "Create self-sign cert and CA key" do
    cwd node['tiger_web']['cert_path']
    command <<-EOF
      openssl req -x509 -days 365 -newkey rsa:2048 -keyout #{node['tiger_web']['URL']}.key -nodes -out #{node['tiger_web']['URL']}.cer -subj "/L=Minsk/C=BY/O=TIGER/OU=TIGR/CN=#{node['tiger_web']['URL']}"
    EOF
    only_if { Dir.empty?("#{node['tiger_web']['cert_path']}") }
  end
