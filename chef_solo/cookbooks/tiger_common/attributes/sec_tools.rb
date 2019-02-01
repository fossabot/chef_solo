default['tiger_common']['nmap_version']='7.40'
default['tiger_common']['nikto_git_path']='https://github.com/sullo/nikto.git'
default['tiger_common']['w3af_git_path']='https://github.com/andresriancho/w3af.git'

#Attributes for UnicornScan
default['tiger_common']['unicornscan_path']=node['tiger_common']['software_path']+'/unicornscan'

#BURP installation
default['tiger_common']['burp_URL'] = 'https://portswigger.net/burp/releases/download?product=free&version=1.7.27&type=jar'
default['tiger_common']['burpa_git_repo'] = 'https://github.com/0x4D31/burpa.git'
default['tiger_common']['burp_rest_git_repo'] = 'https://github.com/vmware/burp-rest-api.git'

#Sslyze installation
default['tiger_common']['sslyze_version'] = '1.3.4'
