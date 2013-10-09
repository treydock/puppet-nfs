require 'spec_helper'

describe 'nfs::rpcbind' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('nfs::rpcbind') }
  it { should contain_class('nfs::params') }

  it do
    should contain_package('rpcbind').with({
      'ensure'    => 'present',
      'name'      => 'rpcbind',
      'before'    => 'Service[rpcbind]',
    })
  end

  it do
    should contain_service('rpcbind').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'rpcbind',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
    })
  end

  context 'with service_ensure => "undef"' do
    let(:params) {{ :service_ensure => "undef" }}
    it { should contain_service('rpcbind').with_ensure(nil) }
  end

  context 'with service_enable => "undef"' do
    let(:params) {{ :service_enable => "undef" }}
    it { should contain_service('rpcbind').with_enable(nil) }
  end
end
