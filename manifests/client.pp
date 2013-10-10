# == Class: nfs
#
# Full description of class nfs here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { nfs: }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class nfs::client (
  $service_name         = $nfs::params::client_service_name,
  $service_ensure       = $nfs::params::client_service_ensure,
  $service_enable       = $nfs::params::client_service_enable,
  $service_hasstatus    = $nfs::params::client_service_hasstatus,
  $service_hasrestart   = $nfs::params::client_service_hasrestart,
  $manage_firewall      = true,
  $portmapper_port      = $nfs::params::portmapper_port,
  $lockd_tcpport        = $nfs::params::lockd_tcpport,
  $lockd_udpport        = $nfs::params::lockd_udpport
) inherits nfs::params {

  require 'nfs'
  include nfs::rpcbind
  include nfs::netfs

  validate_bool($manage_firewall)

  # This gives the option to not manage the service 'ensure' state.
  $service_ensure_real  = $service_ensure ? {
    'undef'   => undef,
    default   => $service_ensure,
  }

  # This gives the option to not manage the service 'enable' state.
  $service_enable_real  = $service_enable ? {
    'undef'   => undef,
    default   => $service_enable,
  }

  $config_path = $nfs::config_path

  if $manage_firewall {
    firewall { '101 portmapper tcp':
      ensure  => present,
      action  => 'accept',
      dport   => $portmapper_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '102 portmapper udp':
      ensure  => present,
      action  => 'accept',
      dport   => $portmapper_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }
    firewall { '103 lockd tcp':
      ensure  => present,
      action  => 'accept',
      dport   => $lockd_tcpport,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '104 lockd udp':
      ensure  => present,
      action  => 'accept',
      dport   => $lockd_udpport,
      chain   => 'INPUT',
      proto   => 'udp',
    }
  }

  Shellvar {
    ensure  => present,
    target  => $config_path,
    notify  => Service['nfslock'],
  }

  shellvar { 'LOCKD_TCPPORT': value   => $lockd_tcpport }
  shellvar { 'LOCKD_UDPPORT': value => $lockd_udpport }

  service { 'nfslock':
    ensure      => $service_ensure_real,
    enable      => $service_enable_real,
    name        => $service_name,
    hasstatus   => $service_hasstatus,
    hasrestart  => $service_hasrestart,
  }

  Service['rpcbind'] -> Service['nfslock']

}
