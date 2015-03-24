shared_examples_for 'nfs::install' do |node|
  case fact('operatingsystemmajrelease')
  when '5'
    rpc_package = 'portmap'
  else
    rpc_package = 'rpcbind'
  end

  describe package('nfs-utils') do
    it { should be_installed }
  end

  describe package('nfs4-acl-tools') do
    it { should be_installed }
  end

  describe package(rpc_package) do
    it { should be_installed }
  end
end
