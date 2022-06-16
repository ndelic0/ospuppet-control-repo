#
# Class: profile::puppet::puppetserver
#
#
class profile::puppet::puppetserver (
  String $puppet_server                  = 'puppet.localdomain',
  Boolean $autosign                      = true,
  Optional[Array[String]] $dns_alt_names = undef,
  Optional[String] $environment          = undef,
) {
  # Configure puppetdb and its underlying database
  $allow_ciphers = [
    'TLS_AES_256_GCM_SHA384',
    'TLS_AES_128_GCM_SHA256',
    'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256',
    'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',
    'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384',
    'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',
  ]

  class { 'puppetdb':
    node_ttl       => '0d',
    node_purge_ttl => '1d',
    ssl_protocols  => 'TLSv1.3,TLSv1.2',
    cipher_suites  => join($allow_ciphers, ','),
  }

  class { 'puppet::server::puppetdb':
    server => $puppet_server,
  }

  # Configure master without Foreman integration
  class { '::puppet':
    autosign                               => $autosign,
    dns_alt_names                          => $dns_alt_names,
    environment                            => $environment,
    hiera_config                           => "${settings::confdir}/hiera.yaml",
    runmode                                => 'unmanaged',
    server                                 => true,
    server_foreman                         => false,
    server_reports                         => 'store',
    server_external_nodes                  => '',
    server_cipher_suites                   => $allow_ciphers,
    additional_settings                    => { color  => 'false', strict => 'off', },
    server_ssl_protocols                   => [ 'TLSv1.3', 'TLSv1.2' ],
    server_check_for_updates               => false,
    server_common_modules_path             => [ '/etc/puppetlabs/code/modules'  ],
    server_compile_mode                    => jit,
    server_environment_class_cache_enabled => true,
    server_jvm_min_heap_size               => '512m',
    server_jvm_max_heap_size               => '512m',
    server_max_requests_per_instance       => 100000,
    server_puppetserver_trusted_agents     => [ $facts['fqdn'] ],
    server_ruby_load_paths                 => [ '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby', '/opt/puppetlabs/puppet/cache/lib' ],
    server_strict_variables                => true,
    show_diff                              => true,
  }

  # resources
}
