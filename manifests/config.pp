# == Class: nfs::config
#
class nfs::config {

  include ::nfs

  $shellvar_notify = $::nfs::server ? {
    true  => [ Service['nfslock'], Service['nfs'] ],
    false => Service['nfslock'],
  }

  file { '/etc/sysconfig/nfs':
    ensure  => 'file',
    path    => $::nfs::service_config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  Shellvar {
    ensure  => 'present',
    target  => $::nfs::service_config_path,
    notify  => $shellvar_notify,
  }

  shellvar { 'LOCKD_TCPPORT': value   => $::nfs::lockd_tcpport }
  shellvar { 'LOCKD_UDPPORT': value => $::nfs::lockd_udpport }

  if $::nfs::server {
    shellvar { 'RQUOTAD_PORT': value => $::nfs::rquotad_port }
    shellvar { 'MOUNTD_PORT': value => $::nfs::mountd_port }
    shellvar { 'RPCNFSDCOUNT': value => $::nfs::rpc_nfsd_count }

    if $::nfs::with_rdma {
      shellvar { 'RDMA_PORT': value => $::nfs::rdma_port }
    }
  }

  if $::nfs::global_defaultvers != 'UNSET'   { nfsmount_config { 'NFSMount_Global_Options/Defaultvers':  value => $::nfs::global_defaultvers } }
  if $::nfs::global_nfsvers != 'UNSET'       { nfsmount_config { 'NFSMount_Global_Options/Nfsvers':      value => $::nfs::global_nfsvers } }
  if $::nfs::global_defaultproto != 'UNSET'  { nfsmount_config { 'NFSMount_Global_Options/Defaultproto': value => $::nfs::global_defaultproto } }
  if $::nfs::global_proto != 'UNSET'         { nfsmount_config { 'NFSMount_Global_Options/Proto':        value => $::nfs::global_proto } }
  if $::nfs::global_soft != 'UNSET'          { nfsmount_config { 'NFSMount_Global_Options/Soft':         value => $::nfs::global_soft } }
  if $::nfs::global_lock != 'UNSET'          { nfsmount_config { 'NFSMount_Global_Options/Lock':         value => $::nfs::global_lock } }
  if $::nfs::global_rsize != 'UNSET'         { nfsmount_config { 'NFSMount_Global_Options/Rsize':        value => $::nfs::global_rsize } }
  if $::nfs::global_wsize != 'UNSET'         { nfsmount_config { 'NFSMount_Global_Options/Wsize':        value => $::nfs::global_wsize } }
  if $::nfs::global_sharecache != 'UNSET'    { nfsmount_config { 'NFSMount_Global_Options/Sharecache':   value => $::nfs::global_sharecache } }

  if $::nfs::manage_idmapd {
    Idmapd_config {
      notify  => Service['rpcidmapd']
    }

    idmapd_config { 'General/Domain': value => $::nfs::idmapd_domain }
  }

}
