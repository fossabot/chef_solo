{
  "#{node['tiger_rest']['apps_path']}/tiger/app/controllers/job_controller.rb" => "job_controller.rb.erb"
}.each do |f,t|

  template "#{f}" do
    source "#{t}"
    action :create
  end

end
