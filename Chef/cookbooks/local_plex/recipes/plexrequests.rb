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
