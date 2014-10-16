# Private class.
class nfs::exports {

  if $nfs::server {
    file { '/etc/exports':
      ensure  => 'file',
      path    => '/etc/exports',
      content => template('nfs/exports.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Exec['exportfs'],
    }

    exec { 'exportfs':
      path        => 'sbin:/bin:/usr/sbin:/usr/bin',
      command     => 'exportfs -r',
      refreshonly => true,
    }
  }

}
