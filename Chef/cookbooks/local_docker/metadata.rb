name             'local_docker'
maintainer       'NoName'
maintainer_email 'NoEmail@NoName.com'
license          'All rights reserved'
description      'Installs/Configures local_docker'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'docker', '~> 2.9.1'
depends 'chef-apt-docker'
