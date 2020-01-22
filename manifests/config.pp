# Private class
class nfs::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $config_notify = $nfs::server ? {
    true  => [ Service['nfslock'], Service['nfs'] ],
    false => Service['nfslock'],
  }

  if $nfs::params::config == 'nfs_config' {
    file { '/etc/nfs.conf':
      ensure => 'file',
      path   => $nfs::service_config_path,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  } else {
    file { '/etc/sysconfig/nfs':
      ensure => 'file',
      path   => $nfs::service_config_path,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  }

  file { '/etc/nfsmount.conf':
    ensure => 'file',
    path   => $nfs::nfsmount_config_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/idmapd.conf':
    ensure => 'file',
    path   => $nfs::idmapd_config_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  if $nfs::params::config == 'nfs_config' {
    Nfs_config {
      ensure  => 'present',
      notify  => $config_notify,
    }
  } else {
    Shellvar {
      ensure  => 'present',
      target  => $nfs::service_config_path,
      notify  => $config_notify,
    }
  }

  if $nfs::configure_ports {
    if $nfs::params::config == 'nfs_config' {
      nfs_config { 'lockd/port': value => $nfs::lockd_tcpport }
      nfs_config { 'lockd/udp-port': value => $nfs::lockd_udpport }
      nfs_config { 'statd/port': value => $nfs::statd_port }
    } else {
      shellvar { 'LOCKD_TCPPORT': value => $nfs::lockd_tcpport }
      shellvar { 'LOCKD_UDPPORT': value => $nfs::lockd_udpport }
      shellvar { 'STATD_PORT': value => $nfs::statd_port }
    }
  }

  if $nfs::server {
    if $nfs::configure_ports {
      if $nfs::params::config == 'nfs_config' {
        nfs_config { 'mountd/port': value => $nfs::mountd_port }
      } else {
        shellvar { 'RQUOTAD_PORT': value => $nfs::rquotad_port }
        shellvar { 'MOUNTD_PORT': value => $nfs::mountd_port }
      }
    }
    if $nfs::params::config == 'nfs_config' {
      nfs_config { 'nfsd/threads': value => $nfs::rpc_nfsd_count }
    } else {
      shellvar { 'RPCNFSDCOUNT': value => $nfs::rpc_nfsd_count }
    }
    if $nfs::rpc_nfsd_args and $nfs::params::config == 'shellvar' {
      shellvar { 'RPCNFSDARGS': value => $nfs::rpc_nfsd_args }
    }

    if $nfs::with_rdma {
      if $nfs::params::config == 'nfs_config' {
        nfs_config { 'nfsd/rdma': value => 'y' }
      } else {
        shellvar { 'RDMA_PORT': value => $nfs::rdma_port }
      }
    }
  }

  if $nfs::global_defaultvers != 'UNSET'   { nfsmount_config { 'NFSMount_Global_Options/Defaultvers':  value => $nfs::global_defaultvers } }
  if $nfs::global_nfsvers != 'UNSET'       { nfsmount_config { 'NFSMount_Global_Options/Nfsvers':      value => $nfs::global_nfsvers } }
  if $nfs::global_defaultproto != 'UNSET'  { nfsmount_config { 'NFSMount_Global_Options/Defaultproto': value => $nfs::global_defaultproto } }
  if $nfs::global_proto != 'UNSET'         { nfsmount_config { 'NFSMount_Global_Options/Proto':        value => $nfs::global_proto } }
  if $nfs::global_soft != 'UNSET'          { nfsmount_config { 'NFSMount_Global_Options/Soft':         value => $nfs::global_soft } }
  if $nfs::global_lock != 'UNSET'          { nfsmount_config { 'NFSMount_Global_Options/Lock':         value => $nfs::global_lock } }
  if $nfs::global_rsize != 'UNSET'         { nfsmount_config { 'NFSMount_Global_Options/Rsize':        value => $nfs::global_rsize } }
  if $nfs::global_wsize != 'UNSET'         { nfsmount_config { 'NFSMount_Global_Options/Wsize':        value => $nfs::global_wsize } }
  if $nfs::global_sharecache != 'UNSET'    { nfsmount_config { 'NFSMount_Global_Options/Sharecache':   value => $nfs::global_sharecache } }

  if $nfs::manage_idmapd {
    Idmapd_config {
      notify  => $nfs::idmapd_config_notify
    }

    idmapd_config { 'General/Domain': value => $nfs::idmapd_domain }
  }

  if $nfs::nfs_callback_tcpport {
    sysctl { 'fs.nfs.nfs_callback_tcpport':
      value => $nfs::nfs_callback_tcpport,
    }
  }

}
