# Configure puppet agent
class profile::puppet::agent {

  systemd::unit_file { 'puppet-onetime.service':
    enable  => true,
    content => epp("${module_name}/puppet-onetime.epp"),
  }

  include profile::puppet::maintenance
}
