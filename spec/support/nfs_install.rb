shared_examples 'nfs::install' do
  it do
    should contain_package('nfs').with({
      :ensure => 'present',
      :name   => 'nfs-utils',
    })
  end

  it do
    should contain_package('rpcbind').with({
      :ensure => 'present',
      :name   => 'rpcbind',
    })
  end
end
