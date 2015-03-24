require 'spec_helper'

describe 'nfs::mount' do
  let :facts do
    {
      :domain                     => 'example.com',
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.4',
    }
  end

  let(:title) { "/mnt/foo" }

  let(:default_params) {{ :device => "192.168.1.1:/export/foo" }}
  let(:params) { default_params }

  it do
    should contain_exec('mkdir-/mnt/foo').with({
      :path     => '/bin:/usr/bin:/sbin:/usr/sbin',
      :command  => 'mkdir -p /mnt/foo',
      :creates  => '/mnt/foo',
      :before   => 'Mount[/mnt/foo]',
    })
  end

  it do
    should contain_file('/mnt/foo').with({
      :ensure   => 'directory',
      :path     => '/mnt/foo',
      :owner    => nil,
      :group    => nil,
      :mode     => nil,
      :require  => 'Mount[/mnt/foo]',
    })
  end

  it do
    should contain_mount('/mnt/foo').with({
      :ensure   => 'mounted',
      :name     => '/mnt/foo',
      :atboot   => 'true',
      :device   => '192.168.1.1:/export/foo',
      :fstype   => 'nfs',
      :options  => 'rw',
      :require  => 'Package[nfs]',
    })
  end

  context "when options is an Array" do
    let(:params) { default_params.merge({ :options => ['rw', 'nfsvers=3']}) }

    it { should contain_mount('/mnt/foo').with_options('rw,nfsvers=3') }
  end

  context "when options is a String" do
    let(:params) { default_params.merge({ :options => 'rw,nfsvers=3'}) }

    it { should contain_mount('/mnt/foo').with_options('rw,nfsvers=3') }
  end

  context "when path => '/mnt/foobar'" do
    let(:params) { default_params.merge({ :path => '/mnt/foobar'}) }

    it do
      should contain_exec('mkdir-/mnt/foo').with({
        :path     => '/bin:/usr/bin:/sbin:/usr/sbin',
        :command  => 'mkdir -p /mnt/foobar',
        :creates  => '/mnt/foobar',
        :before   => 'Mount[/mnt/foo]',
      })
    end

    it do
      should contain_file('/mnt/foo').with({
        :ensure   => 'directory',
        :path     => '/mnt/foobar',
        :owner    => nil,
        :group    => nil,
        :mode     => nil,
        :require  => 'Mount[/mnt/foo]',
      })
    end

    it { should contain_mount('/mnt/foo').with_name('/mnt/foobar') }
  end

  context 'when manage_directory => false' do
    let(:params) { default_params.merge({ :manage_directory => false }) }

    it { should_not contain_exec('mkdir-/mnt/foo') }
    it { should_not contain_file('/mnt/foo') }
  end

  context 'when path is already defined' do
    let(:params) { default_params.merge({ :path => '/mnt/foobar'}) }
    let(:pre_condition) do
      "file { '/mnt/foobar': ensure => directory }"
    end

    it { should_not contain_exec('mkdir-/mnt/foo') }
    it { should_not contain_file('/mnt/foo') }
  end
end
