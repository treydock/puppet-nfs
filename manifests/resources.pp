# == Class: nfs::resources
#
class nfs::resources {

  include ::nfs

  create_resources('nfs::mount', $::nfs::nfs_mounts)

  create_resources(nfsmount_config, $::nfs::nfsmount_configs)

}
