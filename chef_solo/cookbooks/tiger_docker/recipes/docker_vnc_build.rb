git '/tmp/docker-vnc' do
  repository 'https://github.com/ConSol/docker-headless-vnc-container.git'
  reference '1.2.3'
  action :sync
end

ruby_block 'Rename file' do
  block do
    File.rename('/tmp/docker-vnc/Dockerfile.ubuntu.xfce.vnc','/tmp/docker-vnc/Dockerfile')
  end
  not_if {File.exists?("/tmp/docker-vnc/Dockerfile")}
end


# Build vnc image 
execute "build vnc image" do
  cwd '/tmp/docker-vnc'
  command <<-EOF
    #!/bin/bash
    if [ -z "$(docker images -q nail_vnc 2> /dev/null)" ]; then
      docker build -t nail_vnc .
    fi
  EOF
end
