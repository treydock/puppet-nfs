shared_examples 'nfs::install' do
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
      :name   => 'rpcbind',
    })
  end
end
