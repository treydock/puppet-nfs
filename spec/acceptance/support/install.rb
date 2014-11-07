shared_examples_for 'nfs::install' do |node|
  describe package('nfs-utils') do
    it { should be_installed }
  end

  describe package('nfs4-acl-tools') do
    it { should be_installed }
  end

  describe package('rpcbind') do
    it { should be_installed }
  end
end
