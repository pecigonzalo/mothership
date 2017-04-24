#
# Cookbook Name:: local_plex
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'local_media_server'

user 'Plex' do
  action :create
  comment 'Plex Service'
  uid 2000
  gid 2004
  shell '/sbin/nologin'
end

directory '/home/data/DockerMounts/Plex' do
  owner 'Plex'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/Plex/Config' do
  owner 'Plex'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/home/data/DockerMounts/Plex/Media' do
  to '/home/data/Media'
end

docker_image 'linuxserver/plex' do
  action :pull
  notifies :redeploy, 'docker_container[plex.service]', :immediately
end

docker_container 'plex.service' do
  repo 'linuxserver/plex'
  network_mode 'host'
  env [
    'PUID=2000',
    'PGID=2004',
    'VERSION=1.3.4.3285-b46e0ea'
  ]
  binds [
    '/etc/localtime:/etc/localtime:ro',
    '/home/data/DockerMounts/Plex/Config:/config',
    '/home/data/DockerMounts/Plex/Media:/media'
  ]
  action :create
end

include_recipe 'local_plex::plexpy'
include_recipe 'local_plex::plexrequests'
