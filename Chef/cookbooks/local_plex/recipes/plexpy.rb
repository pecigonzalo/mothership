docker_image 'linuxserver/plexpy' do
  action :pull
  notifies :redeploy, 'docker_container[plexpy.service]', :immediately
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
    '/home/data/DockerMounts/PlexPy/config:/config',
    '/home/data/DockerMounts/Plex/Config/Library/Application Support/Plex Media Server/Logs:/logs:ro'
  ]
  action :create
end
