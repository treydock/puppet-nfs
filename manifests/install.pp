# == Class: nfs::install
#
class nfs::install {

  include ::nfs

  package { 'nfs':
    ensure  => 'present',
    name    => $::nfs::params::package_name,
  }

  package { 'rpcbind':
    ensure  => 'present',
    name    => $::nfs::params::rpc_package_name,
  }

}
