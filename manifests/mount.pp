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
  $ensure                   = 'mounted',
  $atboot                   = true,
  $path                     = $title,
  $options                  = 'rw',
  Boolean $manage_directory = true,
  $owner                    = undef,
  $group                    = undef,
  $mode                     = undef,
) {

  include nfs

  $options_real = $options ? {
    Array   => join($options, ','),
    default => $options,
  }

  if ! defined(File[$path]) and $manage_directory {
    exec { "mkdir-${title}":
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      command => "mkdir -p ${path}",
      creates => $path,
      before  => Mount[$title],
    }

    file { $title:
      ensure  => 'directory',
      path    => $path,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => Mount[$title],
    }
  }

  mount { $title:
    ensure   => $ensure,
    name     => $path,
    atboot   => $atboot,
    device   => $device,
    fstype   => 'nfs',
    options  => $options_real,
    remounts => false,
    require  => Package['nfs'],
  }
}
