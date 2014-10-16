# Private class
class nfs::resources {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  create_resources('nfs::mount', $nfs::nfs_mounts)

  create_resources('nfsmount_config', $nfs::nfsmount_configs)

}
