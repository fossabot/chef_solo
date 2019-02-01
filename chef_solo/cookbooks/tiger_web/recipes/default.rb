#
# Cookbook Name:: tiger_web
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "tiger_web::apache_install"
include_recipe "tiger_web::apache_config"