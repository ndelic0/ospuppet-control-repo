#
# Class: profile::puppet::puppetserver
#
#
class profile::puppet::puppetserver {
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    node_ttl       => '0d',
    node_purge_ttl => '1d',
    ssl_protocols  => 'TLSv1.3,TLSv1.2',
  }
  # resources
}
