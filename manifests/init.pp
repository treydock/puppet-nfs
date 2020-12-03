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
  Boolean $server                     = false,
  $package_ensure                     = 'present',
  Boolean $manage_firewall            = true,
  $firewall_iniface                   = undef,
  $firewall_source                    = undef,
  Boolean $configure_ports            = true,
  $portmapper_port                    = $nfs::params::portmapper_port,
  $lockd_tcpport                      = $nfs::params::lockd_tcpport,
  $lockd_udpport                      = $nfs::params::lockd_udpport,
  $statd_port                         = $nfs::params::statd_port,
  $nfs_callback_tcpport               = undef,
  $service_config_path                = $nfs::params::service_config_path,
  $nfsmount_config_path               = $nfs::params::nfsmount_config_path,
  $global_defaultvers                 = 'UNSET',
  $global_nfsvers                     = 'UNSET',
  $global_defaultproto                = 'UNSET',
  $global_proto                       = 'UNSET',
  $global_soft                        = 'UNSET',
  $global_lock                        = 'UNSET',
  $global_rsize                       = 'UNSET',
  $global_wsize                       = 'UNSET',
  $global_sharecache                  = 'UNSET',
  Boolean $manage_rpcbind             = true,
  $has_netfs                          = $nfs::params::has_netfs,
  Boolean $manage_idmapd              = true,
  $enable_idmapd                      = undef,
  $idmapd_config_path                 = $nfs::params::idmapd_config_path,
  $idmapd_domain                      = $::domain,
  $server_service_ensure              = undef,
  $server_service_enable              = undef,
  Boolean $server_service_autorestart = true,
  $rpc_nfsd_count                     = $nfs::params::rpc_nfsd_count,
  $rpc_nfsd_args                      = undef,
  $nfs_port                           = $nfs::params::nfs_port,
  $rquotad_port                       = $nfs::params::rquotad_port,
  $mountd_port                        = $nfs::params::mountd_port,
  Boolean $with_rdma                  = false,
  $rdma_port                          = $nfs::params::rdma_port,
  Hash $nfs_mounts                    = {},
  Hash $nfsmount_configs              = {},
  Hash $exports                       = {},
) inherits nfs::params {

  if $server {
    $_enable_idmapd_default = true
  } else {
    if $nfs::params::client_uses_idmapd {
      $_enable_idmapd_default = true
    } else {
      $_enable_idmapd_default = false
    }
  }

  $_enable_idmapd = pick($enable_idmapd, $_enable_idmapd_default)

  if $_enable_idmapd {
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

  anchor { 'nfs::start': }
  -> Class['nfs::install']
  -> Class['nfs::config']
  -> Class['nfs::service']
  -> Class['nfs::firewall']
  -> Class['nfs::exports']
  -> Class['nfs::resources']
  -> anchor { 'nfs::end': }

  Package['nfs'] -> Nfs::Mount <| |>
}
