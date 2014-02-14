# == Class: nfs::rpcbind
#
# Manage rpcbind.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class nfs::rpcbind (
$package_name         = $nfs::params::rpcbind_package_name,
$service_name         = $nfs::params::rpcbind_service_name,
$service_ensure       = 'running',
$service_enable       = true,
$service_hasstatus    = $nfs::params::rpcbind_service_hasstatus,
$service_hasrestart   = $nfs::params::rpcbind_service_hasrestart
) inherits nfs::params {

  # This gives the option to not manage the service 'ensure' state.
  $service_ensure_real  = $service_ensure ? {
    /UNSET|undef/ => undef,
    default       => $service_ensure,
  }

  # This gives the option to not manage the service 'enable' state.
  $service_enable_real  = $service_enable ? {
    /UNSET|undef/ => undef,
    default       => $service_enable,
  }

  package { 'rpcbind':
    ensure  => present,
    name    => $package_name,
    before  => Service['rpcbind'],
  }

  service { 'rpcbind':
    ensure      => $service_ensure_real,
    enable      => $service_enable_real,
    name        => $service_name,
    hasstatus   => $service_hasstatus,
    hasrestart  => $service_hasrestart,
  }

}
