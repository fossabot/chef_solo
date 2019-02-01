name 'tiger_docker'
maintainer 'EPM-TIGR'
maintainer_email 'EPM-TIGR'
license 'All Rights Reserved'
description 'Installs/Configures docker CE'
long_description 'Installs/Configures Docker CE and build custom docker image'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'tiger_common'
depends 'tiger_web'


