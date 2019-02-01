apt_update

git "#{node['tiger_common']['software_path']}/w3af" do
  revision '356b14b975039706f4fd7f4f5db5b114cd75f14e'
  repository node['tiger_common']['w3af_git_path']
  action :sync
end


package %w(python-pip libssl-dev libffi-dev libsqlite3-dev libxslt1-dev libyaml-dev libxml2-dev gdebi) do
  action :upgrade
end

directory '/root/.w3af' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "/root/.w3af/startup.conf" do
  source "startup.conf.erb"
end

execute "Install w3af modules" do
  command "pip install bravado==9.2.2 pyClamd==0.4.0 msgpack==0.5.6 diff-match-patch==20121119 lz4==1.1.0 pebble==4.3.8 PyGithub==1.21.0 GitPython==2.1.3 pybloomfiltermmap==0.3.14 esmre==0.3.1 phply==0.9.1 nltk==3.0.1 chardet==3.0.4 tblib==0.2.0 pdfminer==20140328 futures==3.2.0 pyOpenSSL==17.4.0 ndg-httpsclient==0.3.3 pyasn1==0.4.2 lxml==3.4.4 scapy-real==2.2.0-dev guess-language==0.2 cluster==1.1.1b3 msgpack-python==0.5.6 python-ntlm==1.0.1 halberd==0.2.4 darts.util.lru==0.5 Jinja2==2.10 vulndb==0.1.0 markdown==2.6.1 psutil==2.2.1 termcolor==1.1.0 mitmproxy==0.13 ruamel.ordereddict==0.4.8 Flask==0.10.1 PyYAML==3.12 tldextract==1.7.2 ds-store==1.1.2 acora==2.1"
end


ruby_block 'Changing pyOnenSSL W3AF dependency' do
  block do
  requirements=IO.read("#{node['tiger_common']['software_path']}/w3af/w3af/core/controllers/dependency_check/requirements.py")
    fixed_requirements=requirements.gsub("PIPDependency(\'OpenSSL\', \'pyOpenSSL\', \'0.15.1\'),","PIPDependency(\'OpenSSL\', \'pyOpenSSL\', \'17.4.0\'),")
    IO.write("#{node['tiger_common']['software_path']}/w3af/w3af/core/controllers/dependency_check/requirements.py",fixed_requirements)
  end
  action :run
end

