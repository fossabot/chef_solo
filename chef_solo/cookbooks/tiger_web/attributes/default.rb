

default['tiger_web']['URL'] = 'tiger.standalone' 

default['tiger_web']['root_path'] = '/opt/tiger/web' # Path with site-content and certs 
default['tiger_web']['log_path']  = '/var/log/apache2/tiger'
default['tiger_web']['site_path'] = '/opt/tiger/web/site'
default['tiger_web']['cert_path'] = '/opt/tiger/web/ssl/certs'

if ( node['platform_family'] == 'debian' )
  default['tiger_web']['conf_path']='/etc/apache2/sites-enabled'
elsif ( node['platform_family'] == 'rhel' )
  default['tiger_web']['conf_path']='/etc/httpd/conf.d'
end

default['tiger_web']['markup_path']='/opt/tiger/web/site/markup'





