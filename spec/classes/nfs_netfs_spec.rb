require 'spec_helper'

describe 'nfs::netfs' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('nfs::netfs') }
  it { should contain_class('nfs::params') }

  it do
    should contain_service('netfs').with({
      'ensure'      => 'running',
      'enable'      => 'true',
      'name'        => 'netfs',
      'hasstatus'   => 'true',
      'hasrestart'  => 'true',
    })
  end

  context 'with service_ensure => "undef"' do
    let(:params) {{ :service_ensure => "undef" }}
    it { should contain_service('netfs').with_ensure(nil) }
  end

  context 'with service_enable => "undef"' do
    let(:params) {{ :service_enable => "undef" }}
    it { should contain_service('netfs').with_enable(nil) }
  end
end
