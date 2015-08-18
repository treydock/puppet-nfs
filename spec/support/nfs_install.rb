shared_examples 'nfs::install' do |facts|
  case facts[:operatingsystemmajrelease]
  when '7'
    rpc_package = 'rpcbind'
  when '6'
    rpc_package = 'rpcbind'
  when '5'
    rpc_package = 'portmap'
  end

  it do
    should contain_package('nfs').with({
      :ensure => 'present',
      :name   => 'nfs-utils',
    })
  end

  it do
    should contain_package('nfs4-acl-tools').with({
      :ensure => 'present',
      :name   => 'nfs4-acl-tools',
    })
  end

  it do
    should contain_package('rpcbind').with({
      :ensure => 'present',
      :name   => rpc_package,
    })
  end

  context 'when manage_rpcbind => false' do
    let(:params) {{ :manage_rpcbind => false }}

    it 'should not manage rpcbind package' do
      should_not contain_package('rpcbind')
    end
  end
end
