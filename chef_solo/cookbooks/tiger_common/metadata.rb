name             'tiger_common'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures tiger_common'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'centos'
supports 'ubuntu'
supports 'redhat'

depends 'influxdb', '= 6.0.0'
depends 'chef-grafana', '= 0.3.0'
