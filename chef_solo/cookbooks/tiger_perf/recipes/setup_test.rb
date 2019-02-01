
require 'pathname'


{
  "#{node['tiger_perf']['node_results_path']}/markup" => "markup",
  "#{node['tiger_perf']['scripts_path']}/tiger_extensions" => "tiger_extensions" ,
}.each do |dir_path,dir_source|
  remote_directory dir_path do
    source dir_source
    files_owner "root"
    files_group "root"
    mode "0775"
  end
end

# Read JVM_ARGS and JMETER_OPTS from perf repo and insert them into jmeter.sh
ruby_block 'Adding external parameters for Jmeter' do
  block do
    require 'yaml'
    require 'pathname'
    main_yml_conf = YAML.load_file("#{node['tiger_perf']['main_yml_path']}")
    tool_name = main_yml_conf["#{node['tiger_perf']['tests_type']}"]['tool']
    case tool_name
      when 'jmeter'
        jmeter_yml_path=Pathname.new("#{node['tiger_perf']['main_yml_path']}").parent+"jmeter/#{node["tiger_perf"]["tests_type"]}.yml"
        jmeter_yml = YAML.load_file(jmeter_yml_path)
        node.default["tiger_perf"]["jvm_args"] = jmeter_yml['jmeter']['JVM_ARGS'] if jmeter_yml['jmeter']['JVM_ARGS']
        node.default["tiger_perf"]["jmeter_opts"] = jmeter_yml['jmeter']['JMETER_OPTS'] if jmeter_yml['jmeter']['JMETER_OPTS']
        node.default["jmeter_path"] = jmeter_yml['jmeter']['path'].chomp('jmeter')
        node.default["jmeter_version"]= "#{jmeter_yml['jmeter']['path']}"[/\d[.]\d/]
    end
  end
end

template "Replacing of jmeter.sh" do
  source lazy {"jmeter#{node['jmeter_version']}.erb"}
  path lazy {"#{node['jmeter_path']}jmeter.sh"}
  #owner 'root'
  #group 'root'
  mode '0755'
end

{
#  "#{node['tiger_perf']['node_results_path']}/tests_summary.html"=>'tests_summary.html.erb',
  "#{node['tiger_perf']['node_results_path']}/markup/tests_settings.html"=>'tests_settings.html.erb',
#  "#{node['tiger_perf']['node_results_path']}/data/tests_summary_footer.tmp"=>'tests_summary_footer.tmp.erb',
  "#{node['tiger_perf']['scripts_path']}/jmeter_metrics_helper.rb" => "jmeter_metrics_helper.rb.erb",
  "#{node['tiger_perf']['scripts_path']}/tiger_extension.rb" => "tiger_extension.rb.erb",
  "#{node['tiger_perf']['scripts_path']}/html_helper.rb" => "html_helper.rb.erb",
  "#{node['tiger_perf']['scripts_path']}/taurus.rb" => "taurus.rb.erb",
  "#{node['tiger_perf']['scripts_path']}/jmeter.rb" => "jmeter.rb.erb",
  "#{node['tiger_perf']['scripts_path']}/encr_helper.rb" => "encr_helper.rb.erb",
  "#{node['tiger_perf']['scripts_path']}/html_report_helper.rb" => "html_report_helper.rb.erb",
  "#{node['tiger_perf']['scripts_path']}/influx.rb"=>'influx.rb.erb',
  "#{node['tiger_perf']['scripts_path']}/sessions_operations.rb" => 'sessions_operations.rb.erb',
  "#{node['tiger_perf']['scripts_path']}/run_performance_tests.rb" => "run_performance_tests.rb.erb"
}.each do |f,t|
  template "#{f}" do
    source "#{t}"
    action :create
  end
end