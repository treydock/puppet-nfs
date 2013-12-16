# == Define: nfs::mount
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
define nfs::mount (
  $device,
  $ensure   = 'mounted',
  $atboot   = true,
  $path     = 'UNSET',
  $options  = 'rw'
) {

  include nfs::params

  $path_real = $path ? {
    'UNSET' => $name,
    default => $path,
  }

  $options_real = is_array($options) ? {
    true    => join($options, ','),
    default => $options,
  }

  $path_params = { 'ensure' => 'directory' }
  ensure_resource( 'file', $path_real, $path_params )

  mount { $name:
    ensure  => $ensure,
    name    => $path_real,
    atboot  => $atboot,
    device  => $device,
    fstype  => 'nfs',
    options => $options_real,
    require => [ Package['nfs'], File[$path_real] ],
  }
}
