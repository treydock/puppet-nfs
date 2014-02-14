# == Define: nfs::mount
#
# Create NFS mounts.
#
# === Examples
#
#  nfs::mount { '/mnt/foo':
#    device => '192.168.1.1:/exports/foo',
#  }
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
