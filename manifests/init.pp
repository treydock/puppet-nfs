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
  $global_defaultvers         = 'UNSET',
  $global_nfsvers             = 'UNSET',
  $global_defaultproto        = 'UNSET',
  $global_proto               = 'UNSET',
  $global_soft                = 'UNSET',
  $global_lock                = 'UNSET',
  $global_rsize               = 'UNSET',
  $global_wsize               = 'UNSET',
  $global_sharecache          = 'UNSET',
  $manage_idmapd              = true,
  $idmapd_domain              = $::domain,
  $server_service_autorestart = true,
  $rpc_nfsd_count             = $nfs::params::rpc_nfsd_count,
  $nfs_port                   = $nfs::params::nfs_port,
  $rquotad_port               = $nfs::params::rquotad_port,
  $mountd_port                = $nfs::params::mountd_port,
  $with_rdma                  = false,
  $rdma_port                  = $nfs::params::rdma_port,
  $nfs_mounts                 = {},
  $nfsmount_configs           = {},
) inherits nfs::params {

  validate_bool($server)
  validate_bool($manage_firewall)
  validate_bool($manage_idmapd)
  validate_bool($server_service_autorestart)
  validate_bool($with_rdma)
  validate_hash($nfs_mounts)
  validate_hash($nfsmount_configs)

  Package['nfs'] -> Nfsmount_config<| |>

  anchor { 'nfs::start': }->
  class { 'nfs::install': }->
  class { 'nfs::config': }->
  class { 'nfs::service': }->
  class { 'nfs::firewall': }->
  class { 'nfs::resources': }->
  anchor { 'nfs::end': }

}
