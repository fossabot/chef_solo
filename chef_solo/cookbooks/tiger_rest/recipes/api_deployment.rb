remote_directory "#{node['tiger_rest']['apps_path']}/tiger" do
  source "tiger"
  files_owner "root"
  files_group "root"
  mode "0775"
end

remote_directory "/opt/tiger/docker" do
  source "docker"
  files_owner "root"
  files_group "root"
  mode "0775"
end

remote_directory "/opt/tiger/certs" do
  source "certs"
  files_owner "root"
  files_group "root"
  mode "0775"
end

if ( node['platform_family'] == 'debian' )
  template "/etc/systemd/system/tiger_rest.service" do
    source 'tiger_rest.erb'
    action :create
  end
elsif ( node['platform_family'] == 'rhel' )
  template "/etc/init.d/tiger_rest" do
    source 'tiger_rest_centos_initd.erb'
    action :create
    mode 0755
  end
end  

{
  "#{node['tiger_rest']['apps_path']}/tiger/app/controllers/job_controller.rb"=>"job_controller.rb.erb",
  "#{node['tiger_rest']['infrastructure_file_path']}/tiger_infrastructure.yml"=>"tiger_infrastructure.yml.erb",
  "#{node['tiger_rest']['apps_path']}/tiger/config/environments/development.rb"=>"development.rb.erb"
}.each do |file_to_generate,template|

  template file_to_generate do
    source template
    action :create
  end
end



script "Launching TIGER REST API application" do
  interpreter 'bash'
  cwd "#{node['tiger_rest']['apps_path']}/tiger"
  code <<-EOH
    mkdir -p "#{node['tiger_rest']['tests_path']}"
    /usr/local/bin/bundle install
    /usr/local/bin/rails db:migrate RAILS_ENV=development 
    ln -s /usr/local/bin/ruby /usr/bin/ruby
    chmod +x bin/rails
  EOH
end

service 'tiger_rest' do
  action [ :enable, :start]
end
