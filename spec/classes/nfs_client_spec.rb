require 'spec_helper'
=begin
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












  end
end
=end