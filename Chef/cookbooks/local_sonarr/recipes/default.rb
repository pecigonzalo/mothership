#
# Cookbook Name:: local_sonarr
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'local_media_server'

user 'Sonarr' do
  action :create
  comment 'Sonarr Service'
  uid 2003
  gid 2004
  shell '/sbin/nologin'
end

directory '/home/data/DockerMounts/Sonarr' do
  owner 'Sonarr'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/Sonarr/Config' do
  owner 'Sonarr'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/home/data/DockerMounts/Sonarr/Media' do
  to '/home/data/Media'
end

docker_image 'linuxserver/sonarr' do
  action :pull
  notifies :redeploy, 'docker_container[sonarr]', :immediately
end

docker_container 'sonarr' do
  repo 'linuxserver/sonarr'
  env [
    'PUID=2003',
    'PGID=2004'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/home/data/DockerMounts/Sonarr/Config:/config',
    '/home/data/DockerMounts/Sonarr/Media:/media'
  ]
  network_mode 'proxied'
  action :create
end

systemd_service 'sonarr' do
  description 'Sonarr Service'
  after %w(docker.service)
  install do
    wanted_by 'multi-user.target'
  end
  service do
    exec_start '/usr/bin/docker start -a sonarr'
    exec_stop '/usr/bin/docker stop -t 2 sonarr'
    restart_sec '10'
    restart 'on-success'
  end
end

service 'sonarr' do
  action [:enable, :start]
end
