class ha_puppet::proxy ($proxy_listener) {

  include haproxy

  haproxy::listen {$proxy_listener:
    ipaddress => $::ipaddress,
    ports     => '8140',
  }

}
