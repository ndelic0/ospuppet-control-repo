#
class role::puppetserver {
  include profile::base
  include profile::puppet::puppetserver
  include profile::example
}
