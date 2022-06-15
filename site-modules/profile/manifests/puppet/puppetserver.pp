#
# Class: profile::puppet::puppetserver
#
#
class profile::puppet::puppetserver {
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    node_ttl => '0d', 
  }
  # resources
}
