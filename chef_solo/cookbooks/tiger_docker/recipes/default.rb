#
# Cookbook:: tiger_docker
# Recipe:: default
#

include_recipe 'tiger_docker::docker_install'
include_recipe 'tiger_docker::docker_vnc_build'
include_recipe 'tiger_docker::docker_build'