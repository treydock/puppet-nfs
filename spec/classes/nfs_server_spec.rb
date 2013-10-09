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

  it "should create valid content for /etc/sysconfig/nfs" do
    verify_contents(subject, '/etc/sysconfig/nfs', [
      'RQUOTAD_PORT=875',
      'LOCKD_TCPPORT=32803',
      'LOCKD_UDPPORT=32769',
      'RPCNFSDCOUNT=8',
      'MOUNTD_PORT=892',
      '#RDMA_PORT=20049',
    ])
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

  context 'with service_ensure => "undef"' do
    let(:params) {{ :service_ensure => "undef" }}
    it { should contain_service('nfs').with_ensure(nil) }
  end

  context 'with service_enable => "undef"' do
    let(:params) {{ :service_enable => "undef" }}
    it { should contain_service('nfs').with_enable(nil) }
  end

  context 'with service_autorestart => false' do
    let(:params) {{ :service_autorestart => false }}
    it { should contain_service('nfs').with_subscribe(nil) }
  end

  context "with rpc_nfsd_count => 16" do
    let(:params) {{ :rpc_nfsd_count => 16 }}

    it "should set RPCNFSDCOUNT=16" do
      verify_contents(subject, '/etc/sysconfig/nfs', ['RPCNFSDCOUNT=16'])
    end
  end

  context 'with with_rdma => true' do
    let(:params) {{ :with_rdma => true }}

    it "should set RDMA_PORT=20049" do
      verify_contents(subject, '/etc/sysconfig/nfs', ['RDMA_PORT=20049'])
    end
  end
end
