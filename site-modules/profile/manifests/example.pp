class profile::example {

  file { '/root/file.ks':
    ensure => present,
    content => template('profile/example/file.erb')
  }

}
