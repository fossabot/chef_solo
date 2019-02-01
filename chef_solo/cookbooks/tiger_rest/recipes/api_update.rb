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


{
  "/etc/systemd/system/tiger_rest.service" => 'tiger_rest.erb',
  "#{node['tiger_rest']['apps_path']}/tiger/app/controllers/job_controller.rb" => "job_controller.rb.erb"
}.each do |f,t|

  template "#{f}" do
    source "#{t}"
    action :create
  end

end
