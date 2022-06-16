#
# Class: profile::puppet::puppetserver
#
#
class profile::puppet::puppetserver {
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

  # Configure master without Foreman integration
  class { '::puppet':
    server                                 => true,
    server_foreman                         => false,
    server_reports                         => 'store',
    server_external_nodes                  => '',
    server_cipher_suites                   => $allow_ciphers,
    additional_settings                    => {
      color  => 'false',
      strict => 'off',
    },
    server_ssl_protocols                   => [ 'TLSv1.3', 'TLSv1.2' ],
    server_check_for_updates               => false,
    server_common_modules_path             => [ '/etc/puppetlabs/code/modules'  ],
    server_compile_mode                    => jit,
    server_environment_class_cache_enabled => true,
  }

  # resources
}
