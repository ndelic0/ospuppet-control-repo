# Manages Puppetboard
class profile::puppet::puppetboard {
  class {'puppetboard':
    manage_git          => true,
    manage_virtualenv   => true,
    reports_count       => 30,
    default_environment => '*',
  }

  # Access Puppetboard from example.com/puppetboard
  class { 'puppetboard::apache::conf': }
}
