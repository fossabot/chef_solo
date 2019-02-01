[
  "curl -O https://nmap.org/dist/nmap-#{node['tiger_common']['nmap_version']}.tar.bz2",
  "bzip2 -cd nmap-7.40.tar.bz2 | tar xvf -",
  "cd nmap-7.40 && bash configure && make && make install"
 # "make",
 # "make install"
].each do |cmd|
  execute "Executing #{cmd}" do
    command cmd # nassl"
    retries 3
  end
end
