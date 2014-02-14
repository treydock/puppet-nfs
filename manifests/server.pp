# == Class: nfs
#
# Manage NFS servers.
#
# === Examples
#
#  class { 'nfs::server': }
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class nfs::server (
  $service_name         = $nfs::params::server_service_name,
  $service_ensure       = 'running',
  $service_enable       = true,
  $service_hasstatus    = $nfs::params::server_service_hasstatus,
  $service_hasrestart   = $nfs::params::server_service_hasrestart,
  $service_autorestart  = true,
  $manage_firewall      = true,
  $rpc_nfsd_count       = $nfs::params::rpc_nfsd_count,
  $nfs_port             = $nfs::params::nfs_port,
  $rquotad_port         = $nfs::params::rquotad_port,
  $mountd_port          = $nfs::params::mountd_port,
  $with_rdma            = false,
  $rdma_port            = $nfs::params::rdma_port
) inherits nfs::params {

  require 'nfs::client'

  validate_bool($service_autorestart)
  validate_bool($manage_firewall)
  validate_bool($with_rdma)

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

  $service_subscribe = $service_autorestart ? {
    true  => File['/etc/sysconfig/nfs'],
    false => undef,
  }

  $config_path = $nfs::config_path

  if $manage_firewall {
    firewall { '105 nfs tcp':
      ensure  => present,
      action  => 'accept',
      dport   => $nfs_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '106 nfs udp':
      ensure  => present,
      action  => 'accept',
      dport   => $nfs_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }
    firewall { '107 rquotad tcp':
      ensure  => present,
      action  => 'accept',
      dport   => $rquotad_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '108 rquotad udp':
      ensure  => present,
      action  => 'accept',
      dport   => $rquotad_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }
    firewall { '109 mountd tcp':
      ensure  => present,
      action  => 'accept',
      dport   => $mountd_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '110 mountd udp':
      ensure  => present,
      action  => 'accept',
      dport   => $mountd_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }

    if $with_rdma {
      firewall { '111 nfs rdma tcp':
        ensure  => present,
        action  => 'accept',
        dport   => $rdma_port,
        chain   => 'INPUT',
        proto   => 'tcp',
      }
      firewall { '112 nfs rdma udp':
        ensure  => present,
        action  => 'accept',
        dport   => $rdma_port,
        chain   => 'INPUT',
        proto   => 'udp',
      }
    }
  }

  Shellvar {
    ensure  => present,
    target  => $config_path,
    notify  => Service['nfs'],
  }

  shellvar { 'RQUOTAD_PORT': value => $rquotad_port }
  shellvar { 'MOUNTD_PORT': value => $mountd_port }
  if $with_rdma { shellvar { 'RDMA_PORT': value => $rdma_port } }

  shellvar { 'RPCNFSDCOUNT': value => $rpc_nfsd_count }

#  File <| title == '/etc/sysconfig/nfs' |> { content => template('nfs/nfs.erb') }

  service { 'nfs':
    ensure      => $service_ensure_real,
    enable      => $service_enable_real,
    name        => $service_name,
    hasstatus   => $service_hasstatus,
    hasrestart  => $service_hasrestart,
    subscribe   => $service_subscribe,
  }

  if $with_rdma {
    service { 'nfs-rdma':
      ensure      => running,
      enable      => true,
      name        => 'nfs-rdma',
      hasstatus   => true,
      hasrestart  => true,
      require     => Package['rdma'],
    }
  }

  Service['rpcbind'] -> Service['nfslock'] -> Service['nfs']


}
