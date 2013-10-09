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
class nfs (
$package_name         = $nfs::params::package_name,
$config_path          = $nfs::params::config_path
) inherits nfs::params {

  package { 'nfs':
    ensure  => present,
    name    => $package_name,
    before  => File['/etc/sysconfig/nfs'],
  }

  file { '/etc/sysconfig/nfs':
    ensure  => present,
    path    => $config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
