#
# Cookbook Name:: local_media_server
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

base_media = '/home/data/Media'

directory 'Create Base Media Folder' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  path base_media
  recursive true
  action :create
end

directory 'Create Movies Folder' do
  owner 'CouchPotato'
  group 'MediaServices'
  mode '2775'
  path "#{base_media}/Movies"
  recursive true
  action :create
end

directory 'Create Series Folder' do
  owner 'Sonarr'
  group 'MediaServices'
  mode '2775'
  path "#{base_media}/Series"
  recursive true
  action :create
end

directory 'Create Torrents Folder' do
  owner 'Deluge'
  group 'MediaServices'
  mode '2775'
  path "#{base_media}/Torrents"
  recursive true
  action :create
end

docker_network 'proxied' do
  action :create
end
