require 'spec_helper'

describe 'nfs::client' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('nfs::client') }
  it { should contain_class('nfs::params') }
  it { should include_class('nfs') }
  it { should include_class('nfs::rpcbind') }
  it { should include_class('nfs::netfs') }

  it_behaves_like "nfs::client firewall" do
    let(:default_params) {{}}
  end

  it do
    should contain_shellvar('LOCKD_TCPPORT').with({
      'ensure'  => 'present',
      'target'  => '/etc/sysconfig/nfs',
      'notify'  => 'Service[nfslock]',
      'value'   => '32803',
    })
  end

  it do
    should contain_shellvar('LOCKD_UDPPORT').with({
      'ensure'  => 'present',
      'target'  => '/etc/sysconfig/nfs',
      'notify'  => 'Service[nfslock]',
      'value'   => '32769',
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

  # Test service ensure and enable 'magic' values
  [
    'undef',
    'UNSET',
  ].each do |v|
    context "with service_ensure => '#{v}'" do
      let(:params) {{ :service_ensure => v }}
      it { should contain_service('nfslock').with_ensure(nil) }
    end

    context "with service_enable => '#{v}'" do
      let(:params) {{ :service_enable => v }}
      it { should contain_service('nfslock').with_enable(nil) }
    end
  end

  context 'with nfs_mounts defined' do
    let :params do
      {
        :nfs_mounts => {
          'foo' => {
            'device'  => '192.168.1.1:/foo',
            'path'    => '/foo',
            'options' => 'rw,nfsvers=3',
          },
        }
      }
    end

    it { should contain_nfs__mount('foo') }
  end
end
