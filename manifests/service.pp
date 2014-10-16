# == Class: nfs::service
#
class nfs::service {

  include ::nfs
  include ::nfs::params

  $server_service_subscribe = $::nfs::server_service_autorestart ? {
    true  => File['/etc/sysconfig/nfs'],
    false => undef,
  }

  if $::nfs::params::has_netfs {
    service { 'netfs':
      ensure     => $::nfs::params::netfs_service_ensure,
      enable     => $::nfs::params::netfs_service_enable,
      name       => $::nfs::params::netfs_service_name,
      hasstatus  => $::nfs::params::netfs_service_hasstatus,
      hasrestart => $::nfs::params::netfs_service_hasrestart,
    }
  }

  service { 'rpcbind':
    ensure     => $::nfs::params::rpc_service_ensure,
    enable     => $::nfs::params::rpc_service_enable,
    name       => $::nfs::params::rpc_service_name,
    hasstatus  => $::nfs::params::rpc_service_hasstatus,
    hasrestart => $::nfs::params::rpc_service_hasrestart,
  }->
  service { 'nfslock':
    ensure     => $::nfs::params::lock_service_ensure,
    enable     => $::nfs::params::lock_service_enable,
    name       => $::nfs::params::lock_service_name,
    hasstatus  => $::nfs::params::lock_service_hasstatus,
    hasrestart => $::nfs::params::lock_service_hasrestart,
  }

  if $::nfs::server {
    service { 'nfs':
      ensure     => $::nfs::params::server_service_ensure,
      enable     => $::nfs::params::server_service_enable,
      name       => $::nfs::params::server_service_name,
      hasstatus  => $::nfs::params::server_service_hasstatus,
      hasrestart => $::nfs::params::server_service_hasrestart,
      subscribe  => $server_service_subscribe,
      require    => Service['nfslock'],
    }

#    if $::nfs::with_rdma {
#      service { 'nfs-rdma':
#        ensure      => 'running',
#        enable      => true,
#        name        => 'nfs-rdma',
#        hasstatus   => true,
#        hasrestart  => true,
#        require     => Package['rdma'],
#      }
#    }
  }

  if $::nfs::manage_idmapd {
    service { 'rpcidmapd':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
