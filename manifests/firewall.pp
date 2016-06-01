# Private class
class nfs::firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $nfs::manage_firewall {
    firewall { '101 portmapper tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::portmapper_port,
      chain   => 'INPUT',
      proto   => 'tcp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '102 portmapper udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::portmapper_port,
      chain   => 'INPUT',
      proto   => 'udp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '103 lockd tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::lockd_tcpport,
      chain   => 'INPUT',
      proto   => 'tcp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '104 lockd udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::lockd_udpport,
      chain   => 'INPUT',
      proto   => 'udp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '105 statd tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::statd_port,
      chain   => 'INPUT',
      proto   => 'tcp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '106 statd udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::statd_port,
      chain   => 'INPUT',
      proto   => 'udp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
  }

  if $nfs::manage_firewall and $nfs::server {
    firewall { '105 nfs tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::nfs_port,
      chain   => 'INPUT',
      proto   => 'tcp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '106 nfs udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::nfs_port,
      chain   => 'INPUT',
      proto   => 'udp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '107 rquotad tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::rquotad_port,
      chain   => 'INPUT',
      proto   => 'tcp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '108 rquotad udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::rquotad_port,
      chain   => 'INPUT',
      proto   => 'udp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '109 mountd tcp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::mountd_port,
      chain   => 'INPUT',
      proto   => 'tcp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }
    firewall { '110 mountd udp':
      ensure  => 'present',
      action  => 'accept',
      dport   => $nfs::mountd_port,
      chain   => 'INPUT',
      proto   => 'udp',
      iniface => $nfs::firewall_iniface,
      source  => $nfs::firewall_source,
    }

    if $nfs::with_rdma {
      firewall { '111 nfs rdma tcp':
        ensure  => 'present',
        action  => 'accept',
        dport   => $nfs::rdma_port,
        chain   => 'INPUT',
        proto   => 'tcp',
        iniface => $nfs::firewall_iniface,
        source  => $nfs::firewall_source,
      }
      firewall { '112 nfs rdma udp':
        ensure  => 'present',
        action  => 'accept',
        dport   => $nfs::rdma_port,
        chain   => 'INPUT',
        proto   => 'udp',
        iniface => $nfs::firewall_iniface,
        source  => $nfs::firewall_source,
      }
    }
  }

}
