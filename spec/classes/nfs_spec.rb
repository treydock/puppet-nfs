require 'spec_helper'

describe 'nfs' do
  include_context :defaults

  let(:facts) { default_facts }

  it { should create_class('nfs') }
  it { should contain_class('nfs::params') }

  it do
    should contain_package('nfs').with({
      'ensure'    => 'present',
      'name'      => 'nfs-utils',
      'before'    => 'File[/etc/sysconfig/nfs]',
    })
  end

  it do
    should contain_file('/etc/sysconfig/nfs').with({
      'ensure'  => 'present',
      'path'    => '/etc/sysconfig/nfs',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
    })
  end
end
