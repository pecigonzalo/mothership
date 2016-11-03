#
# Cookbook Name:: local_docker
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'chef-apt-docker'

docker_installation_package 'default' do
  version node['zenmate_docker']['version']
  action :create
end

docker_service 'default' do
  #log_driver 'journald'
  storage_driver 'aufs'
  action [:create, :start]
end
