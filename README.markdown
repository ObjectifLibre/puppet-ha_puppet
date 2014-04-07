# ha_puppet module #

This module provides a way of deploying new puppet masters automatically.

## Usage ##


```puppet
class{'ha_puppet':
  server          => 'puppetmaster1.example.corp',
  proxy_listener  => 'puppetproxy',
  repo_url        => 'git@git.example.com:ol/puppet.git',
}


