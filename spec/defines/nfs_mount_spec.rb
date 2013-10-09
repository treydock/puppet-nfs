require 'spec_helper'

describe 'nfs::mount' do
  include_context :defaults

  let(:facts) { default_facts }

  let(:title) { "/mnt/foo" }

  let(:default_params) {{ :device => "192.168.1.1:/export/foo" }}
  let(:params) { default_params }

  it { should contain_file('/mnt/foo').with_ensure('directory') }

  it do
    should contain_mount('/mnt/foo').with({
      'ensure'  => 'mounted',
      'atboot'  => 'true',
      'device'  => '192.168.1.1:/export/foo',
      'fstype'  => 'nfs',
      'options' => 'rw',
      'require' => [ 'Package[nfs]', 'File[/mnt/foo]' ],
    })
  end

  context "with options as an Array" do
    let(:params) { default_params.merge({ :options => ['rw', 'nfsvers=3']}) }

    it { should contain_mount('/mnt/foo').with_options('rw,nfsvers=3') }
  end
end
