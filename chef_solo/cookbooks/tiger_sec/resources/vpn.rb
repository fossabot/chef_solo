property :vpn_id, String, name_property: true

action :create do
  require 'json'
  require 'fileutils'
  Chef::Log.info "VPN ID: #{new_resource.vpn_id}"
  FileUtils.mkdir_p node['tiger_sec']['vpn_files_path'] unless IO::File.exist?(node['tiger_sec']['vpn_files_path'])
  node.default['tiger_sec']['vpn_data_bag']=Chef::EncryptedDataBagItem.load("tiger_vpn",new_resource.vpn_id, node['vpn_key'])
  Chef::Log.info node['tiger_sec']['vpn_data_bag']['config_file_name']
  @file_name=''
  @file_content=''
  
  node['tiger_sec']['vpn_data_bag'].to_hash.each do |key,value|
    if (key =~ /name/)
      node.default['tiger_sec']['vpn'][key]=value
      @file_name=value
    end
    if (key =~ /content/)
      @file_content=value
      Chef::Log.info "Writing file name: #{@file_name}"
      IO::File.write("#{node['tiger_sec']['vpn_files_path']}/#{@file_name}",@file_content)
    end
  end
end


