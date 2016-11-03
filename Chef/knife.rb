local_mode true
chef_repo_path   File.expand_path('../', __FILE__)
cookbook_path    [
  File.expand_path('../site-cookbooks', __FILE__)
]

knife[:before_bootstrap] = 'berks vendor -q "$(pwd)/site-cookbooks"'
knife[:before_converge]  = 'berks vendor -q "$(pwd)/site-cookbooks"'

knife[:ssh_attribute] = 'knife_zero.host'
knife[:use_sudo] = true
knife[:identity_file] = '~/.ssh/Github_pecigonzalo'

knife[:automatic_attribute_whitelist] = %w(
  fqdn
  os
  os_version
  hostname
  ipaddress
  roles
  recipes
  ipaddress
  platform
  platform_version
  cloud
  cloud_v2
  chef_packages
)

### Optional.
## If you use attributes from cookbooks for set credentials or dynamic values.
## This option is useful to managing node-objects which are managed under version controle systems(e.g git).
# knife[:default_attribute_whitelist] = []
# knife[:normal_attribute_whitelist] = []
# knife[:override_attribute_whitelist] = []
