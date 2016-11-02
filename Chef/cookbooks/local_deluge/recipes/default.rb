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
  path '/data/Media'
  recursive true
  action :create
end

directory '/data/DockerMounts/Deluge' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/Deluge/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/data/DockerMounts/Deluge/Media' do
  to '/data/Media'
end

docker_image 'pecigonzalo/deluge' do
  tag 'dev'
  action :pull
end

docker_container 'deluge.service' do
  repo 'pecigonzalo/deluge'
  tag 'dev'
  network_mode 'host'
  env [
    'PUID=2001',
    'PGID=2004'
  ]
  binds [
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/Deluge/Media/Torrents:/torrents',
    '/data/DockerMounts/Deluge/Media/Movies:/movies',
    '/data/DockerMounts/Deluge/Config:/config'
  ]
  action :create
end
