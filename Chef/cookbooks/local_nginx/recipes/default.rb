#
# Cookbook Name:: local_nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user 'NGINX' do
  action :create
  comment 'NGINX Service'
  uid 2006
  gid 2005
  shell '/sbin/nologin'
end

directory '/home/data/DockerMounts/NGINX' do
  owner 'NGINX'
  group 'NGINX'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/NGINX/Config' do
  owner 'NGINX'
  group 'NGINX'
  mode '2775'
  action :create
end

docker_image 'linuxserver/nginx' do
  action :pull
end

docker_container 'nginx.service' do
  repo  'linuxserver/nginx'
  port  ['80:80', '443:443']
  env [
    'PUID=2006',
    'PGID=2005'
  ]
  links ['sonarr.service:sonarr',
         'plexrequests.service:plexr',
         'couchpotato.service:couchpotato',
         'wordpress.service:wordpress'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/home/data/DockerMounts/NGINX/Config:/config'
  ]
  action :create
end
