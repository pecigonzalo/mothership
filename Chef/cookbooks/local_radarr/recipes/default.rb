#
# Cookbook Name:: local_radarr
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'local_media_server'

user 'radarr' do
  action :create
  comment 'radarr Service'
  uid 2010
  gid 2004
  shell '/sbin/nologin'
end

directory '/home/data/DockerMounts/radarr' do
  owner 'radarr'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/radarr/Config' do
  owner 'radarr'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/home/data/DockerMounts/radarr/Media' do
  to '/home/data/Media'
end

docker_image 'linuxserver/radarr' do
  action :pull
  notifies :redeploy, 'docker_container[radarr]', :immediately
end

docker_container 'radarr' do
  repo 'linuxserver/radarr'
  env [
    'PUID=2010',
    'PGID=2004'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/home/data/DockerMounts/radarr/Config:/config',
    '/home/data/DockerMounts/radarr/Media:/media'
  ]
  network_mode 'proxied'
  action :create
end

systemd_service 'radarr' do
  description 'Radarr Server'
  after %w(docker.service)
  install do
    wanted_by 'multi-user.target'
  end
  service do
    exec_start '/usr/bin/docker start -a radarr'
    exec_stop '/usr/bin/docker stop -t 2 radarr'
    restart_sec '10'
    restart 'always'
  end
end

service 'radarr' do
  action [:enable, :start]
end
