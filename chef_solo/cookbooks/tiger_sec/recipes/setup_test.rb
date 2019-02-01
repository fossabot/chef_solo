
require 'pathname'


{
  "#{node['tiger_sec']['node_results_path']}/markup" => "markup",
  "#{node['tiger_sec']['scripts_path']}/certs" => "certs",
  "#{node['tiger_sec']['qualys_xml']}" => "qualys_xml"
}.each do |dir_path,dir_source|
  remote_directory dir_path do
    source dir_source
    files_owner "root"
    files_group "root"
    mode "0775"
  end
end


{
  "#{node['tiger_sec']['node_results_path']}/markup/tests_settings.html"=>'tests_settings.html.erb',
  "#{node['tiger_sec']['scripts_path']}/html_helper.rb" => "html_helper.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/html_report_helper.rb" => "html_report_helper.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/run_security_tests.rb" => "run_security_tests.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/nmap.rb" => "nmap.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/nikto.rb" => "nikto.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/sslyze.rb" => "sslyze.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/w3af.rb" => "w3af.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/burp.rb" => "burp.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/run_burp_headless.sh" => "run_burp_headless.sh.erb",
  "#{node['tiger_sec']['scripts_path']}/launch_burp.sh" =>"launch_burp.sh.erb",
  "#{node['tiger_sec']['scripts_path']}/not_vulnerable_hash.yml" => "not_vulnerable_hash.yml.erb",
  "#{node['tiger_sec']['scripts_path']}/masscan.rb" => "masscan.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/w3af_cmd_file_addition.tmp" => "w3af_cmd_file_addition.tmp.erb",
  "#{node['tiger_sec']['scripts_path']}/zap.rb" => "zap.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/influx.rb" => "influx.rb.erb",
  "#{node['tiger_sec']['scripts_path']}/qualys.rb" => "qualys.rb.erb"
}.each do |f,t|
  template "#{f}" do
    source "#{t}"
    action :create
  end
end
