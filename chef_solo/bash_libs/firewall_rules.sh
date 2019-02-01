#!/bin/bash

function ubuntu_open_ports {
	# Add ports which should be opened for Tiger project(Ubuntu)
	if  [ $(which ufw) ]; then
	  ufw enable
	  ufw allow 22
	  ufw allow 80
	  ufw allow 443
	  ufw allow 2003
	  ufw allow 2004
	  ufw allow 3000
	  ufw allow 3100
	  ufw allow 5601    # For Kibana
	  ufw allow 5044    # For ElasticSearch
	  ufw allow 8086
	  ufw reload
	fi
}

function centos_open_ports {
	# Add ports which should be opened for Tiger project(CentOS 6)
	/sbin/iptables -I INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 2003 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 2004 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3000 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3100 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 5601 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 5044 -m state --state NEW -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 8086 -m state --state NEW -j ACCEPT
	/sbin/service iptables save
	/sbin/service iptables restart
}