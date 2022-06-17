# Manages Puppetboard
class profile::puppet::puppetboard {
  class { 'puppetboard':
    manage_git        => true,
    manage_virtualenv => true,
  }
}
