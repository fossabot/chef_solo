# Attributes for Docker installation
default['tiger_docker']['docker_version'] = '17.06.0'
default['tiger_docker']['docker_URL']     = "https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_#{ node['tiger_docker']['docker_version']}~ce-0~ubuntu_amd64.deb"
default['tiger_docker']['docker_registry_path'] = "/opt/tiger/docker_register" 
default['tiger_docker']['docker_pkg'] = node['tiger_docker']['docker_URL'].split('/').last

# Attributes for Docker build
default['tiger_docker']['image_path'] = '/opt/tiger/docker/tiger_image'
default['tiger_docker']['image_name'] = 'nail1'
default['tiger_docker']['dev_image_name'] = node['tiger_docker']['image_name'] +"_dev"
 # Git EPM-TIGER
 default['tiger_docker']['tiger_repo']        = ""
 default['tiger_docker']['tiger_repo_branch'] = 'master'

# Git repos for security tools
default['tiger_docker']['ext_git_repos'] = {
  'sslyze'=>'https://github.com/nabla-c0d3/sslyze.git',
  'openssl'=>'https://github.com/PeterMosmans/openssl.git',
  'nassl'=>'https://github.com/nabla-c0d3/nassl.git',
  'nikto'=>'https://github.com/sullo/nikto.git',
  'w3af'=>'https://github.com/andresriancho/w3af.git',
  'ruby-build'=>'https://github.com/sstephenson/ruby-build.git'
 }
