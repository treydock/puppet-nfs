# == Class: nfs::client
#
# Manages NFS clients.
#
# === Parameters
#
# === Examples
#
#  class { 'nfs::client': }
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
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_hasstatus    = $nfs::params::client_service_hasstatus,
  $service_hasrestart   = $nfs::params::client_service_hasrestart,
  $manage_firewall      = true,
  $portmapper_port      = $nfs::params::portmapper_port,
  $lockd_tcpport        = $nfs::params::lockd_tcpport,
  $lockd_udpport        = $nfs::params::lockd_udpport,
  $nfs_mounts           = {},
  $nfsmount_configs     = {}
) inherits nfs::params {

  require 'nfs'
  include nfs::rpcbind
  include nfs::netfs

  validate_bool($manage_firewall)
  validate_hash($nfs_mounts)
  validate_hash($nfsmount_configs)

  Package['nfs'] -> Nfsmount_config<| |>

  if !empty($nfs_mounts) {
    create_resources('nfs::mount', $nfs_mounts)
  }

  if $nfsmount_configs and !empty($nfsmount_configs) {
    create_resources(nfsmount_config, $nfsmount_configs)
  }

  # This gives the option to not manage the service 'ensure' state.
  $service_ensure_real  = $service_ensure ? {
    /UNSET|undef/ => undef,
    default       => $service_ensure,
  }

  # This gives the option to not manage the service 'enable' state.
  $service_enable_real  = $service_enable ? {
    /UNSET|undef/ => undef,
    default       => $service_enable,
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
