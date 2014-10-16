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
  $ensure           = 'mounted',
  $atboot           = true,
  $path             = 'UNSET',
  $options          = 'rw',
  $manage_directory = true,
) {

  $path_real = $path ? {
    'UNSET' => $title,
    default => $path,
  }

  $options_real = is_array($options) ? {
    true    => join($options, ','),
    default => $options,
  }

  if $manage_directory {
    if ! defined(File[$path_real]) {
      file { $path_real:
        ensure => 'directory',
      }
    }
  }

  mount { $title:
    ensure  => $ensure,
    name    => $path_real,
    atboot  => $atboot,
    device  => $device,
    fstype  => 'nfs',
    options => $options_real,
    require => [ Package['nfs'], File[$path_real] ],
  }
}
