# Wordpress

# Create Users
group 'Wordpress' do
  action :create
  append false
  gid 2005
end

user 'Wordpress' do
  action :create
  comment 'Wordpress Service'
  uid 2005
  gid 2005
  shell '/sbin/nologin'
end

group 'Wordpress' do
  action :modify
  members %w(
    Wordpress)
  append false
end

git '/tmp/docker-wordpress' do
  repository 'https://github.com/pecigonzalo/docker-wordpress.git'
  revision 'master'
  action :sync
end

docker_image 'pecigonzalo/wordpress' do
  tag 'wordpress'
  source '/tmp/docker-wordpress'
  action :build
end

docker_image 'linuxserver/mariadb' do
  action :pull
end

directory '/data/DockerMounts/wordpress_db' do
  owner 2005
  group 2005
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/wordpress_db/Config' do
  owner 2005
  group 2005
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
    '/data/DockerMounts/wordpress_db/Config:/config',
  ]
  action :create
end

directory '/data/DockerMounts/wordpress_nginx' do
  owner 2005
  group 2005
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/wordpress_nginx/Config' do
  owner 2005
  group 2005
  mode '2775'
  action :create
end

docker_container 'wordpress.nginx.service' do
  repo 'wordpress'
  env [
    'PUID=2005',
    'PGID=2005'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/wordpress_nginx/Config:/config',
  ]
  action :create
end

