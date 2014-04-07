class ha_puppet (
  $is_primary            = false,
  $server                = "puppet.${::domain}",
  $ca_server             = $server,
  $storeconfigs_dbserver = $server,
  $dashboard_host        = "${server}:3000",
  $repo_url              = undef,
  $proxy_listener        = undef,
  ) {

  if($is_primary) {
    class{'::puppet::master':
      ca                     => true,
      reports                => 'http',
      reporturl              => "http://${dashboard_host}/reports/upload",
      storeconfigs           => true,
      storeconfigs_dbserver  => $storeconfigs_dbserver,
    }
  }
  else {
    class{'::puppet::master':
      ca                    => false,
      reports               => 'http',
      reporturl             => "http://${dashboard_host}/reports/upload",
      storeconfigs          => true,
      storeconfigs_dbserver => $storeconfigs_dbserver,
      ssl_cert              => "/var/lib/puppet/ssl/certs/${::clientcert}.pem",
      ssl_key               => "/var/lib/puppet/ssl/private_keys/${::clientcert}.pem",
      ssl_chain             => '/var/lib/puppet/ssl/certs/ca.pem',
      ssl_ca                => '/var/lib/puppet/ssl/certs/ca.pem',
      ssl_crl               => '/var/lib/puppet/ssl/crl.pem',
    }
  }

  if($repo_url) {
    class{'::r10k':
      remote => $repo_url,
    }
    if ($git_ssh_key) {
      # TODO : save the ssh key and create a ssh_config? Maybe we should leave
      # this to the user?
      # before => Class['r10k']
    }
  }


  if($proxy_listener) {
    @@haproxy::balancermember{"${::clientcert}_8140":
      listening_service => $proxy_listener,
      server_names      => $::clientcert,
      ipaddresses       => $::ipaddress,
      ports             => '8140',
      options           => ['check inter 2000', 'fall 3'],
    }
  }

}
