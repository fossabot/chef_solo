#!/bin/bash
# Perform installation as root
# Install prereqs
 
yum -y install epel-release wget libcurl libcurl-devel rrdtool rrdtool-devel rrdtool-perl libgcrypt-devel gcc make gcc-c++
 
# Get Collectd, untar it, make it and install
 
wget -P /tmp http://collectd.org/files/collectd-5.5.1.tar.gz 
cd /tmp && tar zxvf collectd-5.5.1.tar.gz && \ 
cd collectd-5.5.1 && \
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib64 --mandir=/usr/share/man --enable-all-plugins
make
make install 
 
 
# Copy the default init.d script
dir="$(cd "$(dirname $0)" && pwd)"
cp $dir/collectd-5.5.1/contrib/redhat/init.d-collectd /etc/init.d/collectd
 
# Set the correct permissions
 
chmod +x /etc/init.d/collectd
 
# Start the deamon
 
service collectd start