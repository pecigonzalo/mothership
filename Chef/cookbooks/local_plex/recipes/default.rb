#
# Cookbook Name:: local_plex
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user 'Plex' do
  action :create
  comment 'Plex Service'
  uid 2000
  gid 2004
  shell '/sbin/nologin'
end

directory 'Create Media Folder for Plex' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  path '/data/Media'
  recursive true
  action :create
end

directory '/data/DockerMounts/Plex' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/Plex/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/data/DockerMounts/Plex/Media' do
  to '/data/Media'
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
    'PGID=2004'
  ]
  binds [
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/Plex/Config:/config',
    '/data/DockerMounts/Plex/Media:/media'
  ]
  action :create
end

include_recipe 'local_plex::plexpy'
include_recipe 'local_plex::plexrequests'
