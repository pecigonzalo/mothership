# Creat Groups
group 'MediaServices' do
  action :create
  append false
  gid 2004
end

# Create Users
user 'Plex' do
  action :create
  comment 'Plex Service'
  uid 2000
  gid 2004
  shell '/sbin/nologin'
end

user 'Deluge' do
  action :create
  comment 'Deluge Service'
  uid 2001
  gid 2004
  shell '/sbin/nologin'
end

user 'CouchPotato' do
  action :create
  comment 'CouchPotato Service'
  uid 2002
  gid 2004
  shell '/sbin/nologin'
end

user 'Sonarr' do
  action :create
  comment 'Sonarr Service'
  uid 2003
  gid 2004
  shell '/sbin/nologin'
end

group 'MediaServices' do
  action :modify
  members %w(
    Plex
    Deluge
    CouchPotato
    Sonarr)
  append false
end

# Media folder permissions
directory '/data/Media' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

# Couch Potato

directory '/data/DockerMounts/CouchPotato' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/CouchPotato/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/data/DockerMounts/CouchPotato/Media' do
  to '/data/Media'
end

docker_image 'linuxserver/couchpotato' do
  action :pull
end

docker_container 'couchpotato.service' do
  repo 'linuxserver/couchpotato'
  env [
    'PUID=2002',
    'PGID=2004'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/CouchPotato/Config:/config',
    '/data/DockerMounts/CouchPotato/Media/Torrents:/downloads',
    '/data/DockerMounts/CouchPotato/Media/Movies:/movies'
  ]
  action :create
end

# Deluge

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

# Plex

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

# Sonarr

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

# Plex Requests

directory '/data/DockerMounts/PlexRequests' do
  owner 'root'
  group 'root'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/PlexRequests/Config' do
  owner 'root'
  group 'root'
  mode '2775'
  action :create
end

docker_image 'lsiodev/plexrequests' do
  action :pull
end

docker_container 'plexrequests.service' do
  repo  'lsiodev/plexrequests'
  env [
    'URL_BASE=/plexr'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/PlexRequests/Config:/config'
  ]
  action :create
end

# HTPC Manager

directory '/data/DockerMounts/HTPCManager' do
  owner 'root'
  group 'root'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/HTPCManager/Config' do
  owner 'root'
  group 'root'
  mode '2775'
  action :create
end

docker_image 'linuxserver/htpcmanager' do
  action :pull
end

docker_container 'htpcmanager.service' do
  repo  'linuxserver/htpcmanager'
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/HTPCManager/Config:/config'
  ]
  action :create
end

# h5ai

directory '/data/DockerMounts/h5ai' do
  owner 'root'
  group 'root'
  mode '2775'
  recursive true
  action :create
end

directory '/data/DockerMounts/h5ai/Config' do
  owner 'root'
  group 'root'
  mode '2775'
  action :create
end

link '/data/DockerMounts/h5ai/Media' do
  to '/data/Media'
end

docker_image 'paulvalla/docker-h5ai' do
  action :pull
end

docker_container 'h5ai.service' do
  repo  'paulvalla/docker-h5ai'
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/h5ai/Config:/etc/nginx',
    '/data/DockerMounts/h5ai/Media:/var/www'
  ]
  action :create
end

# PlexPy

docker_image 'linuxserver/plexpy' do
  action :pull
end

docker_container 'plexpy.service' do
  repo  'linuxserver/plexpy'
  network_mode 'host'
  env [
    'PUID=2000',
    'PGID=2004'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/PlexPy/config:/config',
    '/data/DockerMounts/Plex/Config/Library/Application Support/Plex Media Server/Logs:/logs:ro'
  ]
  action :create
end


# NGINX

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
         'h5ai.service:h5ai',
         'couchpotato.service:couchpotato',
         'htpcmanager.service:htpcmanager',
         'wordpress.db.service',
         'wordpress.nginx.service'
  ]
  binds [
    '/dev/rtc:/dev/rtc:ro',
    '/etc/localtime:/etc/localtime:ro',
    '/data/DockerMounts/NGINX/Config:/config'
  ]
  action :create
end
