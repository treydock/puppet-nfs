# == Class: nfs::firewall
#
class nfs::firewall {

  include ::nfs

#  Firewall {
#    ensure  => 'present',
#    action  => 'accept',
#    chain   => 'INPUT',
#  }

  if $::nfs::manage_firewall {
    firewall { '101 portmapper tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::portmapper_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '102 portmapper udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::portmapper_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }
    firewall { '103 lockd tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::lockd_tcpport,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '104 lockd udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::lockd_udpport,
      chain   => 'INPUT',
      proto   => 'udp',
    }
  }

  if $::nfs::manage_firewall and $::nfs::server {
    firewall { '105 nfs tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::nfs_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '106 nfs udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::nfs_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }
    firewall { '107 rquotad tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::rquotad_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '108 rquotad udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::rquotad_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }
    firewall { '109 mountd tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::mountd_port,
      chain   => 'INPUT',
      proto   => 'tcp',
    }
    firewall { '110 mountd udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $::nfs::mountd_port,
      chain   => 'INPUT',
      proto   => 'udp',
    }

    if $::nfs::with_rdma {
      firewall { '111 nfs rdma tcp':
        ensure  => 'present',
        action  => 'accept',
        dport   => $::nfs::rdma_port,
        chain   => 'INPUT',
        proto   => 'tcp',
      }
      firewall { '112 nfs rdma udp':
        ensure  => 'present',
        action  => 'accept',
        dport   => $::nfs::rdma_port,
        chain   => 'INPUT',
        proto   => 'udp',
      }
    }
  }

}
