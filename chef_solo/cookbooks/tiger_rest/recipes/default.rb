#
# Cookbook Name:: tiger_rest
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#include_recipe "tiger_common::users_setup"
include_recipe 'tiger_rest::ror_install'
include_recipe 'tiger_rest::api_deployment'
include_recipe 'tiger_rest::ror_logrotation'

