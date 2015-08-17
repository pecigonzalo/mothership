# Install Ajenti
apt_repository "ajenti" do
  uri "http://repo.ajenti.org/debian"
  distribution "main"
  components ["main"]
  key "http://repo.ajenti.org/debian/key"
  action :add
end

package ['ajenti'] do
  action :install
end

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
  action :create
end

link '/opt/CouchPotato' do
  to '/mnt2/DockerMounts/CouchPotato'
end

link '/opt/CouchPotato/Media' do
  to '/mnt2/Media'
end

docker_container 'couchpotato.service' do
  repo 'linuxserver/couchpotato'
  port '5050:5050'
  memory '512m'
  env [
    'PUID=1003', 
    'PGID=1003'
  ]
  volumes [
    '/etc/localtime:/etc/localtime:ro',
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
  action :create
end

link '/opt/Deluge' do
  to '/mnt2/DockerMounts/Deluge'
end

link '/opt/Deluge/Media' do
  to '/mnt2/Media'
end

docker_container 'deluge.service' do
  repo 'pecigonzalo/deluge'
  network_mode 'host'
  memory '128m'
  env [
    'PUID=1004', 
    'PGID=1003'
  ]
  volumes [
    '/etc/localtime:/etc/localtime:ro',
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
  action :create
end

link '/opt/Plex' do
  to '/mnt2/DockerMounts/Plex'
end

link '/opt/Plex/Media' do
  to '/mnt2/Media'
end

docker_container 'plex.service' do
  repo 'linuxserver/plex'
  network_mode 'host'
  memory '512m'
  env [
    'PUID=1001', 
    'PGID=1003'
  ]
  volumes [
    '/etc/localtime:/etc/localtime:ro',
    '/opt/PlexMediaServer/Config:/config',
    '/opt/PlexMediaServer/Media:/media'
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
  action :create
end

link '/opt/Sonarr' do
  to '/mnt2/DockerMounts/Sonarr'
end

link '/opt/Sonarr/Media' do
  to '/mnt2/Media'
end

docker_container 'sonarr.service' do
  repo 'linuxserver/sonarr'
  port '8989:8989'
  memory '512m'
  env [
    'PUID=1002', 
    'PGID=1003'
  ]
  volumes [
    '/etc/localtime:/etc/localtime:ro',
    '/opt/Sonarr/Config:/config',
    '/opt/Sonarr/Media:/media'
  ]
  action :create
end