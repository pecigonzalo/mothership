#
# Cookbook Name:: local_users
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Creat Groups
group 'MediaServices' do
  action :create
  append false
  gid 2004
end
