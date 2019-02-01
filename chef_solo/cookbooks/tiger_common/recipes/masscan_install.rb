if ( node['platform_family'] == 'debian' )
  apt_update

  package 'masscan'
elsif ( node['platform_family'] == 'rhel' )
	p 'Nothing to do'
end