# Creat Groups
group 'MediaServices' do
  action :create
  append false
  gid '2004'
end

# Create Users
user 'Plex' do
  action :create
  comment 'Plex Service'
  uid '2000'
  gid '2004'
  shell '/sbin/nologin'
end

user 'Deluge' do
  action :create
  comment 'Deluge Service'
  uid '2001'
  gid '2004'
  shell '/sbin/nologin'
end

user 'CouchPotato' do
  action :create
  comment 'CouchPotato Service'
  uid '2002'
  gid '2004'
  shell '/sbin/nologin'
end

user 'Sonarr' do
  action :create
  comment 'Sonarr Service'
  uid '2003'
  gid '2004'
  shell '/sbin/nologin'
end

group 'MediaServices' do
  action :modify
  members [
    'Plex',
    'Deluge',
    'CouchPotato',
    'Sonarr',
  ]
  append false
end


# Install EPEL
#package 'Install EPEL Repo' do
#  package 'http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'
#  action :install
#end

# Media folder permissions
directory '/mnt2/Media' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

# Couch Potato

directory '/mnt2/DockerMounts/CouchPotato' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/mnt2/DockerMounts/CouchPotato/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/opt/CouchPotato' do
  to '/mnt2/DockerMounts/CouchPotato'
end

link '/opt/CouchPotato/Media' do
  to '/mnt2/Media'
end

docker_image 'linuxserver/couchpotato' do
  action :pull
end

docker_container 'couchpotato.service' do
  repo 'linuxserver/couchpotato'
  port '5050:5050'
  memory 536870912
  env [
    'PUID=2002', 
    'PGID=2004'
  ]
  binds [
    '/opt/CouchPotato/Config:/config',
    '/opt/CouchPotato/Media/Torrents:/downloads',
    '/opt/CouchPotato/Media/Movies:/movies'
  ]
  action :create
end

# Deluge

directory '/mnt2/DockerMounts/Deluge' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/mnt2/DockerMounts/Deluge/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/opt/Deluge' do
  to '/mnt2/DockerMounts/Deluge'
end

link '/opt/Deluge/Media' do
  to '/mnt2/Media'
end

docker_image 'pecigonzalo/deluge' do
  action :pull
end

docker_container 'deluge.service' do
  repo 'pecigonzalo/deluge'
  network_mode 'host'
  memory 536870912
  env [
    'PUID=2001', 
    'PGID=2004'
  ]
  binds [
    '/opt/Deluge/Media/Torrents:/torrents',
    '/opt/Deluge/Config:/config'
  ]
  action :create
end

# Plex

directory '/mnt2/DockerMounts/Plex' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/mnt2/DockerMounts/Plex/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/opt/Plex' do
  to '/mnt2/DockerMounts/Plex'
end

link '/opt/Plex/Media' do
  to '/mnt2/Media'
end

docker_image 'linuxserver/plex' do
  action :pull
end

docker_container 'plex.service' do
  repo 'linuxserver/plex'
  network_mode 'host'
  memory 536870912
  env [
    'PUID=2000', 
    'PGID=2004'
  ]
  binds [
    '/opt/Plex/Config:/config',
    '/opt/Plex/Media:/media'
  ]
  action :create
end

# Sonarr

directory '/mnt2/DockerMounts/Sonarr' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  recursive true
  action :create
end

directory '/mnt2/DockerMounts/Sonarr/Config' do
  owner 'root'
  group 'MediaServices'
  mode '2775'
  action :create
end

link '/opt/Sonarr' do
  to '/mnt2/DockerMounts/Sonarr'
end

link '/opt/Sonarr/Media' do
  to '/mnt2/Media'
end

docker_image 'linuxserver/sonarr' do
  action :pull
end

docker_container 'sonarr.service' do
  repo 'linuxserver/sonarr'
  port '8989:8989'
  memory 536870912
  env [
    'PUID=2003', 
    'PGID=2004'
  ]
  binds [
    '/opt/Sonarr/Config:/config',
    '/opt/Sonarr/Media:/media'
  ]
  action :create
end
