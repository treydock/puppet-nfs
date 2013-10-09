# == Class: nfs
#
# Full description of class nfs here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
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
# === Examples
#
#  class { nfs: }
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
$service_ensure       = $nfs::params::rpcbind_service_ensure,
$service_enable       = $nfs::params::rpcbind_service_enable,
$service_hasstatus    = $nfs::params::rpcbind_service_hasstatus,
$service_hasrestart   = $nfs::params::rpcbind_service_hasrestart
) inherits nfs::params {

  # This gives the option to not manage the service 'ensure' state.
  $service_ensure_real  = $service_ensure ? {
    'undef'   => undef,
    default   => $service_ensure,
  }

  # This gives the option to not manage the service 'enable' state.
  $service_enable_real  = $service_enable ? {
    'undef'   => undef,
    default   => $service_enable,
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
