# Private class
class nfs::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'nfs':
    ensure => $nfs::package_ensure,
    name   => $nfs::params::package_name,
  }

  package { 'nfs4-acl-tools':
    ensure => 'present',
    name   => $nfs::params::nfs4_acl_tools_package_name
  }

  if $nfs::manage_rpcbind {
    package { 'rpcbind':
      ensure => 'present',
      name   => $nfs::params::rpc_package_name,
    }
  }

}
