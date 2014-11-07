# == Class: nfs
#
# Base class shared by NFS clients and servers.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class nfs (
  $server                     = false,
  $manage_firewall            = true,
  $portmapper_port            = $nfs::params::portmapper_port,
  $lockd_tcpport              = $nfs::params::lockd_tcpport,
  $lockd_udpport              = $nfs::params::lockd_udpport,
  $nfsmount_config_path       = $nfs::params::nfsmount_config_path,
  $global_defaultvers         = 'UNSET',
  $global_nfsvers             = 'UNSET',
  $global_defaultproto        = 'UNSET',
  $global_proto               = 'UNSET',
  $global_soft                = 'UNSET',
  $global_lock                = 'UNSET',
  $global_rsize               = 'UNSET',
  $global_wsize               = 'UNSET',
  $global_sharecache          = 'UNSET',
  $has_netfs                  = $nfs::params::has_netfs,
  $manage_idmapd              = true,
  $enable_idmapd              = true,
  $idmapd_config_path         = $nfs::params::idmapd_config_path,
  $idmapd_domain              = $::domain,
  $server_service_ensure      = undef,
  $server_service_enable      = undef,
  $server_service_autorestart = true,
  $rpc_nfsd_count             = $nfs::params::rpc_nfsd_count,
  $nfs_port                   = $nfs::params::nfs_port,
  $rquotad_port               = $nfs::params::rquotad_port,
  $mountd_port                = $nfs::params::mountd_port,
  $with_rdma                  = false,
  $rdma_port                  = $nfs::params::rdma_port,
  $nfs_mounts                 = {},
  $nfsmount_configs           = {},
  $exports                    = {},
) inherits nfs::params {

  validate_bool(
    $server,
    $manage_firewall,
    $manage_idmapd,
    $enable_idmapd,
    $server_service_autorestart,
    $with_rdma
  )

  validate_hash(
    $nfs_mounts,
    $nfsmount_configs,
    $exports
  )

  if $enable_idmapd {
    $idmapd_service_ensure = 'running'
    $idmapd_service_enable = true
    $idmapd_config_notify  = Service['rpcidmapd']
  } else {
    $idmapd_service_ensure = 'stopped'
    $idmapd_service_enable = false
    $idmapd_config_notify  = undef
  }

  include nfs::install
  include nfs::config
  include nfs::service
  include nfs::firewall
  include nfs::exports
  include nfs::resources

  anchor { 'nfs::start': }->
  Class['nfs::install']->
  Class['nfs::config']->
  Class['nfs::service']->
  Class['nfs::firewall']->
  Class['nfs::exports']->
  Class['nfs::resources']->
  anchor { 'nfs::end': }

}
