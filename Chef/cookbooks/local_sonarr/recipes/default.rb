#
# Cookbook Name:: local_sonarr
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user 'Sonarr' do
  action :create
  comment 'Sonarr Service'
  uid 2003
  gid 2004
  shell '/sbin/nologin'
end

directory 'Create Media Folder for Sonarr' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  path '/data/Media'
  recursive true
  action :create
end

directory '/data/DockerMounts/Sonarr' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/Sonarr/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/data/DockerMounts/Sonarr/Media' do
  to '/data/Media'
end

docker_image 'linuxserver/sonarr' do
  action :pull
end

docker_container 'sonarr.service' do
  repo 'linuxserver/sonarr'
  env [
    'PUID=2003',
    'PGID=2004'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/Sonarr/Config:/config',
    '/data/DockerMounts/Sonarr/Media:/media'
  ]
  action :create
end
