#
# Cookbook Name:: local_nginx
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory '/data/DockerMounts/NGINX' do
  owner 'root'
  group 'root'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/NGINX/Config' do
  owner 'root'
  group 'root'
  mode '2775'
  action :create
end

docker_image 'linuxserver/nginx' do
  action :pull
end

docker_container 'nginx.service' do
  repo  'linuxserver/nginx'
  port  ['80:80', '443:443']
  links ['sonarr.service:sonarr',
         'plexrequests.service:plexr',
         'couchpotato.service:couchpotato'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/NGINX/Config:/config'
  ]
  action :create
end
