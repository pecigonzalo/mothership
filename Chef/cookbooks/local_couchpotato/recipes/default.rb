#
# Cookbook Name:: local_couchpotato
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user 'CouchPotato' do
  action :create
  comment 'CouchPotato Service'
  uid 2002
  gid 2004
  shell '/sbin/nologin'
end

directory 'Create Media Folder for CouchPotat' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  path '/data/Media'
  recursive true
  action :create
end

directory '/data/DockerMounts/CouchPotato' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/CouchPotato/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/data/DockerMounts/CouchPotato/Media' do
  to '/data/Media'
end

docker_image 'linuxserver/couchpotato' do
  action :pull
end

docker_container 'couchpotato.service' do
  repo 'linuxserver/couchpotato'
  env [
    'PUID=2002',
    'PGID=2004'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/CouchPotato/Config:/config',
    '/data/DockerMounts/CouchPotato/Media/Torrents:/downloads',
    '/data/DockerMounts/CouchPotato/Media/Movies:/movies'
  ]
  action :create
end
