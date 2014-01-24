require 'spec_helper'

describe 'nfs::server' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('nfs::server') }
  it { should contain_class('nfs::params') }
  it { should include_class('nfs::client') }

  it_behaves_like "nfs::server firewall" do
    let(:default_params) {{}}
  end

  it do
    should contain_shellvar('RQUOTAD_PORT').with({
      'ensure'  => 'present',
      'target'  => '/etc/sysconfig/nfs',
      'notify'  => 'Service[nfs]',
      'value'   => '875',
    })
  end

  it do
    should contain_shellvar('MOUNTD_PORT').with({
      'ensure'  => 'present',
      'target'  => '/etc/sysconfig/nfs',
      'notify'  => 'Service[nfs]',
      'value'   => '892',
    })
  end

  it do
    should contain_service('nfslock').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'nfslock',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
    })
  end

  it { should_not contain_shellvar('RDMA_PORT') }

  it do
    should contain_shellvar('RPCNFSDCOUNT').with({
      'ensure'  => 'present',
      'target'  => '/etc/sysconfig/nfs',
      'notify'  => 'Service[nfs]',
      'value'   => '8',
    })
  end

  it do
    should contain_service('nfs').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'nfs',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
      'subscribe'   => 'File[/etc/sysconfig/nfs]',
    })
  end

  it { should_not contain_server('nfs-rdma') }

  context "with rpc_nfsd_count => 16" do
    let(:params) {{ :rpc_nfsd_count => 16 }}

    it do
      should contain_shellvar('RPCNFSDCOUNT').with({
        'ensure'  => 'present',
        'target'  => '/etc/sysconfig/nfs',
        'notify'  => 'Service[nfs]',
        'value'   => '16',
      })
    end
  end

  context 'with with_rdma => true' do
    let(:params) {{ :with_rdma => true }}

    it do
      should contain_shellvar('RDMA_PORT').with({
        'ensure'  => 'present',
        'target'  => '/etc/sysconfig/nfs',
        'notify'  => 'Service[nfs]',
        'value'   => '20049',
      })
    end

    it do
      should contain_service('nfs-rdma').with({
        'ensure'      => 'running',
        'enable'      => 'true',
        'name'        => 'nfs-rdma',
        'hasstatus'   => 'true',
        'hasrestart'  => 'true',
        'require'     => 'Package[rdma]',
      })
    end
  end

  context 'with service_autorestart => false' do
    let(:params) {{ :service_autorestart => false }}
    it { should contain_service('nfs').with_subscribe(nil) }
  end

  # Test service ensure and enable 'magic' values
  [
    'undef',
    'UNSET',
  ].each do |v|
    context "with service_ensure => '#{v}'" do
      let(:params) {{ :service_ensure => v }}
      it { should contain_service('nfs').with_ensure(nil) }
    end

    context "with service_enable => '#{v}'" do
      let(:params) {{ :service_enable => v }}
      it { should contain_service('nfs').with_enable(nil) }
    end
  end

  # Test boolean validation
  [
    'service_autorestart',
    'manage_firewall',
    'with_rdma',
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param.to_sym => 'foo' }}
      it { expect { should create_class('nfs::server') }.to raise_error(Puppet::Error, /is not a boolean/) }
    end
  end
end
