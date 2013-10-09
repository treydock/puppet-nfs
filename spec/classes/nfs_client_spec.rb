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
    should contain_service('nfslock').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'nfslock',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
    })
  end

  context 'with service_ensure => "undef"' do
    let(:params) {{ :service_ensure => "undef" }}
    it { should contain_service('nfslock').with_ensure(nil) }
  end

  context 'with service_enable => "undef"' do
    let(:params) {{ :service_enable => "undef" }}
    it { should contain_service('nfslock').with_enable(nil) }
  end
end
