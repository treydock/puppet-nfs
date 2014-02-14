# == Class: nfs::netfs
#
# Manage the netfs service.
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2013 Trey Dockendorf
#
class nfs::netfs (
$service_name         = $nfs::params::netfs_service_name,
$service_ensure       = 'running',
$service_enable       = true,
$service_hasstatus    = $nfs::params::netfs_service_hasstatus,
$service_hasrestart   = $nfs::params::netfs_service_hasrestart
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

  if !defined(Service['netfs']) {
    service { 'netfs':
      ensure      => $service_ensure_real,
      enable      => $service_enable_real,
      name        => $service_name,
      hasstatus   => $service_hasstatus,
      hasrestart  => $service_hasrestart,
    }
  }
}
