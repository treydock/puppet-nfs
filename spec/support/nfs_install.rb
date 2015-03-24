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
end
