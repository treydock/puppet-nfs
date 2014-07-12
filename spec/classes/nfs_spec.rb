require 'spec_helper'

describe 'nfs' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('nfs') }
  it { should contain_class('nfs::params') }

  it { should contain_anchor('nfs::start').that_comes_before('Class[nfs::install]') }
  it { should contain_class('nfs::install').that_comes_before('Class[nfs::config]') }
  it { should contain_class('nfs::config').that_comes_before('Class[nfs::service]') }
  it { should contain_class('nfs::service').that_comes_before('Class[nfs::firewall]') }
  it { should contain_class('nfs::firewall').that_comes_before('Class[nfs::resources]') }
  it { should contain_class('nfs::resources').that_comes_before('Anchor[nfs::end]') }
  it { should contain_anchor('nfs::end') }

  it_behaves_like 'nfs::install'
  it_behaves_like 'nfs::config'
  it_behaves_like 'nfs::service'
  it_behaves_like "nfs::firewall"
  it_behaves_like 'nfs::resources'

  # Test boolean validation
  [
    :server,
    :manage_firewall,
    :manage_idmapd,
    :server_service_autorestart,
    :with_rdma,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('nfs') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end

  # Test hash validation
  [
    :nfs_mounts,
    :nfsmount_configs,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param => 'foo' }}
      it { expect { should create_class('nfs') }.to raise_error(Puppet::Error, /is not a Hash/) }
    end
  end

end
