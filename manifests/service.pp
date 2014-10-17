# Private class
class nfs::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $server_service_subscribe = $nfs::server_service_autorestart ? {
    true  => File['/etc/sysconfig/nfs'],
    false => undef,
  }

  if $nfs::server {
    $server_service_ensure  = pick($nfs::server_service_ensure, 'running')
    $server_service_enable  = pick($nfs::server_service_enable, true)
  } else {
    $server_service_ensure  = pick($nfs::server_service_ensure, 'stopped')
    $server_service_enable  = pick($nfs::server_service_enable, false)
  }

  if $nfs::has_netfs {
    service { 'netfs':
      ensure     => $nfs::netfs_service_ensure,
      enable     => $nfs::netfs_service_enable,
      name       => $nfs::netfs_service_name,
      hasstatus  => $nfs::netfs_service_hasstatus,
      hasrestart => $nfs::netfs_service_hasrestart,
    }
  }

  service { 'rpcbind':
    ensure     => $nfs::rpc_service_ensure,
    enable     => $nfs::rpc_service_enable,
    name       => $nfs::rpc_service_name,
    hasstatus  => $nfs::rpc_service_hasstatus,
    hasrestart => $nfs::rpc_service_hasrestart,
  }->
  service { 'nfslock':
    ensure     => $nfs::lock_service_ensure,
    enable     => $nfs::lock_service_enable,
    name       => $nfs::lock_service_name,
    hasstatus  => $nfs::lock_service_hasstatus,
    hasrestart => $nfs::lock_service_hasrestart,
  }

  if $nfs::server {
    service { 'nfs':
      ensure     => $server_service_ensure,
      enable     => $server_service_enable,
      name       => $nfs::server_service_name,
      hasstatus  => $nfs::server_service_hasstatus,
      hasrestart => $nfs::server_service_hasrestart,
      subscribe  => $server_service_subscribe,
      require    => Service['nfslock'],
    }
  }

  if $nfs::manage_idmapd {
    service { 'rpcidmapd':
      ensure     => running,
      enable     => true,
      name       => $nfs::idmap_service_name,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
