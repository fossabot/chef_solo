# Create folders for Tiger
node['tiger_web'].each do |k,v|
  if (k =~/path/)
    directory node['tiger_web'][k] do
      mode 0755
      owner 'root'
      group 'root'
      recursive true
      action :create      
    end
  end
end

# Copy site content
remote_directory "#{ node['tiger_web']['root_path'] }/site" do
  source 'web'
  files_owner "root"
  files_group "root"
  mode "0775"
end

{
  "footer.html.erb" => "#{node['tiger_web']['markup_path']}/footer.html",
  "header.html.erb" => "#{node['tiger_web']['markup_path']}/header.html",
  "index.html.erb" => "#{node['tiger_web']['root_path']}/site/index.html",
  "installation.html.erb" => "#{node['tiger_web']['markup_path']}/installation.html",
  "tiger.conf.erb" => "#{node['tiger_web']['conf_path']}/tiger.conf",
  "tiger_ssl.conf.erb" => "#{node['tiger_web']['conf_path']}/tiger_ssl.conf"
}.each do |t,f|
  template "#{f}" do
    source "#{t}"
    action :create
  end
end

include_recipe "tiger_web::ssl_generate"

# Copy .htpasswd
remote_directory "/etc/#{ node['web-serv'] }" do
    source "apache2"
    files_owner "root"
    files_group "root"
    mode "0775"
end

if ( node['platform_family'] == 'debian' )
  template "/etc/apache2/apache2.conf" do
    source "apache2.conf.erb"
    action :create
  end 
  
  link '/etc/apache2/modules' do
    to '/usr/lib/apache2/modules'
  end

  execute "Renaming default apache2 file 000-default.conf" do
    command "mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf_"
    only_if { File.exist?('/etc/apache2/sites-enabled/000-default.conf')}
  end
elsif ( node['platform_family'] == 'rhel' )  
  file '/etc/httpd/conf.d/ssl.conf' do
    action :delete
  end  
end

# Add URL to host
execute "Add URL to host" do
  command <<-EOF
    echo "#{node['ipaddress']} #{node['tiger_web']['URL']}" >> /etc/hosts
  EOF
  not_if { File.read('/etc/hosts').include? node['tiger_web']['URL'] }
end

[
  node['tiger_web']['site_path'] + "/results",
  node['tiger_web']['site_path'] + "/results/security",
  node['tiger_web']['site_path'] + "/results/performance"
].each do |folder|
  directory folder do
    mode 0755
    owner 'tiger'
    group 'tiger'
    recursive true
    action :create      
  end
end

service node.default['web-serv'] do
  action [ :enable, :restart ]
end

