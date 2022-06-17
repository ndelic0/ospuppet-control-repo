# Manages Puppetboard
class profile::puppet::puppetboard {
  class {'puppetboard':
    manage_git          => true,
    manage_virtualenv   => true,
    reports_count       => 30,
    default_environment => '*',
  }
  class { 'apache':
    purge_configs => false,
    mpm_module    => 'prefork',
    default_vhost => true,
    default_mods  => false,
  }
  class { 'puppetboard::apache::vhost':
    vhost_name => $facts['fqdn'],
    port       => 80,
  }
  class { 'puppetboard::apache::conf': }
  class { 'apache::mod::wsgi':
    wsgi_socket_prefix =>  '/var/run/wsgi',
  }
  # Access Puppetboard from example.com/puppetboard
  class { 'puppetboard::apache::conf': }
}
