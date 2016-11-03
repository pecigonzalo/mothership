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
  path '/home/data/Media'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/CouchPotato' do
  owner 'CouchPotato'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/CouchPotato/Config' do
  owner 'CouchPotato'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/home/data/DockerMounts/CouchPotato/Media' do
  to '/home/data/Media'
end

docker_image 'linuxserver/couchpotato' do
  action :pull
  notifies :redeploy, 'docker_container[couchpotato.service]', :immediately
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
    '/home/data/DockerMounts/CouchPotato/Config:/config',
    '/home/data/DockerMounts/CouchPotato/Media/Torrents:/downloads',
    '/home/data/DockerMounts/CouchPotato/Media/Movies:/movies'
  ]
  action :create
end
