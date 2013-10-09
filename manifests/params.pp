# == Class: nfs::params
#
# The nfs configuration settings.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class nfs::params {

  $rpc_nfsd_count               = '8'

  $server_service_ensure        = 'running'
  $server_service_enable        = true
  $server_service_autorestart   = true
  $client_service_ensure        = 'running'
  $client_service_enable        = true
  $rpcbind_service_ensure       = 'running'
  $rpcbind_service_enable       = true
  $netfs_service_ensure         = 'running'
  $netfs_service_enable         = true

  $portmapper_port              = '111'
  $nfs_port                     = '2049'
  $rquotad_port                 = '875'
  $lockd_tcpport                = '32803'
  $lockd_udpport                = '32769'
  $mountd_port                  = '892'

  $rdma_port                    = '20049'

  case $::osfamily {
    'RedHat': {
      $package_name                 = 'nfs-utils'
      $config_path                  = '/etc/sysconfig/nfs'
      $server_service_name          = 'nfs'
      $server_service_hasstatus     = true
      $server_service_hasrestart    = true
      $client_service_name          = 'nfslock'
      $client_service_hasstatus     = true
      $client_service_hasrestart    = true
      $rpcbind_package_name         = $::operatingsystemrelease ? {
        /^6/  => 'rpcbind',
        /^5/  => 'portmap',
      }
      $rpcbind_service_name         = $::operatingsystemrelease ? {
        /^6/  => 'rpcbind',
        /^5/  => 'portmap',
      }
      $rpcbind_service_hasstatus    = true
      $rpcbind_service_hasrestart   = true
      $netfs_service_name           = 'netfs'
      $netfs_service_hasstatus      = true
      $netfs_service_hasrestart     = true
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}