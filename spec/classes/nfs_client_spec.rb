require 'spec_helper'

describe 'nfs::client' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('nfs::client') }
  it { should contain_class('nfs::params') }
  it { should contain_class('nfs') }
  it { should contain_class('nfs::rpcbind') }
  it { should contain_class('nfs::netfs') }

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

  it { should have_nfsmount_config_resource_count(0) }

  [
    'defaultvers',
    'nfsvers',
    'defaultproto',
    'proto',
    'soft',
    'lock',
    'rsize',
    'wsize',
    'sharecache',
  ].each do |p|
    context "when global_#{p} => 'FOO'" do
      let(:params) {{ :"global_#{p}" => 'FOO' }}
      let(:setting) { p.capitalize }
      it { should have_nfsmount_config_resource_count(1) }
      it { should contain_nfsmount_config("NFSMount_Global_Options/#{setting}").with_value('FOO') }
      it { should contain_package('nfs').that_comes_before("Nfsmount_config[NFSMount_Global_Options/#{setting}]") }
    end
  end

  context "when nfsmount_configs is a Hash" do
    let :params do
      {
        :nfsmount_configs => {'NFSMount_Global_Options/Retrans' => {'value' => 2}}
      }
    end

    it { should have_nfsmount_config_resource_count(1) }

    it { should contain_nfsmount_config('NFSMount_Global_Options/Retrans').with_value('2') }
    it { should contain_package('nfs').that_comes_before('Nfsmount_config[NFSMount_Global_Options/Retrans]') }
  end

  context 'when nfsmount_configs is "foo"' do
    let(:params) {{ :nfsmount_configs => "foo" }}
    it { expect { should create_class('nfs::client') }.to raise_error(Puppet::Error, /is not a Hash/) }
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
