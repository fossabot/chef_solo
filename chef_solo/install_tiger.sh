#!/bin/bash
# This script will install TIGER project on your host

green="\033[32m"
white="\033[0m"
yellow="\033[33m"
red="\033[31m"

chefdk_version="2.0.28"
log_path="/var/log/tiger.install.log"

home_dir="$(cd "$(dirname $0)" && pwd)"

for file in $home_dir/bash_libs/*
do
  source $file
done

check_running_docker_containers

# Detect OS distr. and OS release version 
if [ $(which yum) ]; then
	os_distr=$(cat /etc/redhat-release | awk '{ print $1; }' )
	os_version=$(cat /etc/redhat-release | awk '{ print $(NF-1); }' | cut -d"." -f 1)
	pack_manager=( [1]="yum" [2]="rpm" )
  chefdk_url="https://packages.chef.io/files/stable/chefdk/$chefdk_version/el/$os_version/chefdk-$chefdk_version-1.el$os_version.x86_64.rpm"
elif [ $(which apt-get) ]; then
	os_distr=$( cat /etc/lsb-release | grep -i 'distrib_id' | cut -d"=" -f 2)
	os_version=$( cat /etc/lsb-release | grep -i 'distrib_release' | cut -d"=" -f 2)
	pack_manager=( [1]="apt-get" [2]="dpkg" )
  chefdk_url="https://packages.chef.io/files/stable/chefdk/2.0.28/ubuntu/$os_version/chefdk_$chefdk_version-1_amd64.deb"
fi

default_path="/opt/chefdk/embedded/bin"

echo -e "$yellow Starting TIGER installation"

# Installing CURL ntp ntpdate
${pack_manager[1]} install -y curl ntp ntpdate >> $log_path 2>&1 
check_execution $? "CURL and NTP packages installation "

# Sync time
case "$os_distr" in 
	Ubuntu) ubuntu_time_sync >> $log_path 2>&1 ;;
	CentOS|Red) rh_time_sync >> $log_path 2>&1 ;;
esac
check_execution $? "Time synchronization" 

# Installing chefDK
if [ ! -e $default_path/chef-client ]; then
  curl -OL -k $chefdk_url >> $log_path 2>&1 && ${pack_manager[2]} -i ${chefdk_url##*/} >> $log_path 2>&1 
  check_execution $? "Chef Client is installed" 
fi

# Download dependencies
cd $home_dir/cookbooks/tiger_common
berks vendor $home_dir/cookbooks >> $log_path 2>&1 
check_execution $? "Cookbooks dependencies download completed"

# Apply cookbook
case $1 in
  "dev") runlist="runlist_dev.json";;
  "docker") runlist="runlist_docker.json";;
  "elk") runlist="runlist_elk.json";;
  "grafana") runlist="runlist_grafana.json";;
  "rest") runlist="runlist_rest.json" ;;
  *) runlist="runlist.json"
esac
cd $home_dir
echo "Applying TIGER's cookbooks ..."
chef-client -z -j $home_dir/runlists/$runlist -l info >> $log_path 2>&1
check_execution $? "TIGER is installed"

# disable SELinux
if [ $(which setenforce) ]; then
  echo -e "$yellow Disabling SE Linux $white"
  setenforce 0
  sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  check_execution $? "SELinux disabled"
fi

# Add firewals rules
case "$os_distr" in 
	CentOS|Red) centos_open_ports 2>> $log_path ;;
    Ubuntu) ubuntu_open_ports 2>> $log_path 
esac
check_execution $? "Firewall rules setup completed"

# Set up RoR
cd /opt/tiger/RoR/tiger && bin/rails db:migrate RAILS_ENV=development >> $log_path 2>&1

service docker restart >> $log_path 2>&1

echo -e "Detaled log file -> $log_path "