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