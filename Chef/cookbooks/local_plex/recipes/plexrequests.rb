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

docker_image 'linuxserver/plexrequests' do
  action :pull
  notifies :redeploy, 'docker_container[plexrequests.service]', :immediately
end

docker_container 'plexrequests.service' do
  repo  'linuxserver/plexrequests'
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
