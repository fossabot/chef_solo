#
# Cookbook:: taurus
# Recipe:: taurus_install
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package %w(python default-jre-headless
           python-tk python-pip python-dev
           libxml2-dev libxslt-dev zlib1g-dev) do
    action :upgrade
end

bash 'install Taurus wia pip' do
  code <<-EOF
        pip install bzt
        EOF
  not_if { ::File.exist?('/usr/local/bin/bzt') }
end

