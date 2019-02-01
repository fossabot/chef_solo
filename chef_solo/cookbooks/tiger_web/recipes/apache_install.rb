if ( node['platform_family'] == 'debian' )
  node.default['web-serv'] = 'apache2'
elsif ( node['platform_family'] == 'rhel' )
  node.default['web-serv'] = 'httpd'
  package 'mod_ssl' do
  	action :install
  end
end

package node.default['web-serv'] do
  action :install
end