require 'json'

cmds=[] #["cd /opt/tiger/chef_solo && git pull"]

case ARGV[1]
  when "sec"
    cmds.push "chef-solo -c /opt/tiger/chef_solo/solo.rb -j /opt/tiger/chef_solo/dna_#{ARGV[0]}.json -o \'recipe[tiger_sec]\'"# --logfile /opt/tiger/chef_solo/chef-solo.log"
    cmds.push "ruby /opt/tiger/security/scripts/run_tests.rb"
  when "perf"
    cmds.push "chef-solo -c /opt/tiger/chef_solo/solo.rb -j /opt/tiger/chef_solo/dna_#{ARGV[0]}.json -o \'recipe[tiger_perf]\' --logfile /opt/tiger/chef_solo/chef-solo.log"
end



cmds.each do |cmd|
  unless (system(cmd))
    dna_json=JSON.parse File.read("/opt/tiger/chef_solo/dna_#{ARGV[0]}.json")
    # updating task stus on the REST API server
    puts "Command #{cmd} \n\n failed, updating tasks status"
    puts "Executing curl -X POST --data \"id=#{dna_json['task_id']}&result=finished%20with%20Error:700\" http://#{dna_json['rest_api_fqdn']}:3100/job/update"
    `curl -X POST --data \"id=#{dna_json['job_id']}&result=finished%20with%20Error:700\" http://#{dna_json['lc_ip']}:3100/job/update`
    exit 1
  end
end

