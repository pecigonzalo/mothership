#
# Cookbook Name:: local_wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Wordpress
user 'Wordpress' do
  action :create
  comment 'Wordpress Service'
  uid 2005
  gid 2005
  shell '/sbin/nologin'
end

git '/tmp/docker-wordpress' do
  repository 'https://github.com/pecigonzalo/docker-wordpress.git'
  revision 'master'
  action :sync
  notifies :build, 'docker_image[pecigonzalo/wordpress]', :immediately
end

docker_image 'pecigonzalo/wordpress' do
  source '/tmp/docker-wordpress'
  action :build_if_missing
  notifies :redeploy, 'docker_container[wordpress.service]', :immediately
end

docker_image 'linuxserver/mariadb' do
  action :pull
end

directory '/home/data/DockerMounts/wordpress_db' do
  owner 'Wordpress'
  group 'NGINX'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/wordpress_db/Config' do
  owner 'Wordpress'
  group 'NGINX'
  mode '2775'
  action :create
end

docker_container 'wordpress.db.service' do
  repo 'linuxserver/mariadb'
  env [
    'PUID=2005',
    'PGID=2005',
    'MYSQL_ROOT_PASSWORD=wordpress'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/home/data/DockerMounts/wordpress_db/Config:/config',
  ]
  action :create
end

directory '/home/data/DockerMounts/wordpress_nginx' do
  owner 'Wordpress'
  group 'NGINX'
  mode '2775'
  recursive true
  action :create
end

directory '/home/data/DockerMounts/wordpress_nginx/Config' do
  owner 'Wordpress'
  group 'NGINX'
  mode '2775'
  action :create
end

docker_container 'wordpress.service' do
  repo 'pecigonzalo/wordpress'
  env [
    'PUID=2005',
    'PGID=2005'
  ]
  links [
    'wordpress.db.service:db'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/home/data/DockerMounts/NGINX/Config/backups:/config/backups',
    '/home/data/DockerMounts/NGINX/Config/www:/config/www'
  ]
  action :create
end
