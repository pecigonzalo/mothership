#
# Cookbook Name:: local_deluge
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user 'Deluge' do
  action :create
  comment 'Deluge Service'
  uid 2001
  gid 2004
  shell '/sbin/nologin'
end

directory 'Create Media Folder for Deluge' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  path '/home/data/Media'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/Deluge' do
  owner 'Deluge'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/Deluge/Config' do
  owner 'Deluge'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/home/data/DockerMounts/Deluge/Media' do
  to '/home/data/Media'
end

docker_image 'linuxserver/deluge' do
  action :pull
  notifies :redeploy, 'docker_container[deluge.service]', :immediately
end

docker_container 'deluge.service' do
  repo 'linuxserver/deluge'
  network_mode 'host'
  env [
    'PUID=2001',
    'PGID=2004'
  ]
  binds [
    '/etc/localtime:/etc/localtime:ro',
    '/home/data/DockerMounts/Deluge/Media/Torrents:/torrents',
    '/home/data/DockerMounts/Deluge/Media/Movies:/movies',
    '/home/data/DockerMounts/CouchPotato/Media:/downloads',
    '/home/data/DockerMounts/Deluge/Config:/config'
  ]
  action :create
end
