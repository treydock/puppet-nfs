# Private class
class nfs::params {

  $rpc_nfsd_count               = '8'

  $lock_service_ensure          = 'running'
  $lock_service_enable          = true
  $rpc_service_ensure           = 'running'
  $rpc_service_enable           = true
  $netfs_service_ensure         = 'running'
  $netfs_service_enable         = true

  $portmapper_port              = '111'
  $nfs_port                     = '2049'
  $rquotad_port                 = '875'
  $lockd_tcpport                = '32803'
  $lockd_udpport                = '32769'
  $mountd_port                  = '892'
  $statd_port                   = '662'

  $rdma_port                    = '20049'

  case $::osfamily {
    'RedHat': {
      $package_name                 = 'nfs-utils'
      $nfs4_acl_tools_package_name  = 'nfs4-acl-tools'
      $service_config_path          = '/etc/sysconfig/nfs'
      $nfsmount_config_path         = '/etc/nfsmount.conf'
      $idmapd_config_path           = '/etc/idmapd.conf'
      $server_service_hasstatus     = true
      $server_service_hasrestart    = true
      $lock_service_hasstatus       = true
      $lock_service_hasrestart      = true
      if versioncmp($::operatingsystemrelease, '7.0') >= 0 {
        $has_netfs                  = false
        $client_uses_idmapd         = false
        $idmapd_can_enable          = false
        $lock_service_name          = 'rpc-statd'
        $rpc_package_name           = 'rpcbind'
        $rpc_service_name           = 'rpcbind'
        $idmap_service_name         = 'nfs-idmapd'
        $server_service_name        = 'nfs-server'
      } elsif versioncmp($::operatingsystemrelease, '6.0') < 0 {
        $has_netfs                  = true
        $client_uses_idmapd         = true
        $idmapd_can_enable          = true
        $lock_service_name          = 'nfslock'
        $rpc_package_name           = 'portmap'
        $rpc_service_name           = 'portmap'
        $idmap_service_name         = 'rpcidmapd'
        $server_service_name        = 'nfs'
      } else {
        $has_netfs                  = true
        $client_uses_idmapd         = true
        $idmapd_can_enable          = true
        $lock_service_name          = 'nfslock'
        $rpc_package_name           = 'rpcbind'
        $rpc_service_name           = 'rpcbind'
        $idmap_service_name         = 'rpcidmapd'
        $server_service_name        = 'nfs'
      }
      $rpc_service_hasstatus        = true
      $rpc_service_hasrestart       = true
      $netfs_service_name           = 'netfs'
      $netfs_service_hasstatus      = true
      $netfs_service_hasrestart     = true
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
