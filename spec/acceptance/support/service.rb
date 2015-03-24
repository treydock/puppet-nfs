case fact('operatingsystemmajrelease')
when '5'
  rpc_service   = 'portmap'
  lock_service  = 'nfslock'
  idmap_service = 'rpcidmapd'
when '6'
  rpc_service   = 'rpcbind'
  lock_service  = 'nfslock'
  idmap_service = 'rpcidmapd'
when '7'
  rpc_service   = 'rpcbind'
  lock_service  = 'nfs-lock'
  idmap_service = 'nfs-idmap'
end

shared_examples_for 'nfs::service-base' do |node|
  if fact('operatingsystemmajrelease') < '7'
    describe service('netfs') do
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe service(rpc_service) do
    it { should be_enabled }
    it { should be_running }
  end

  describe service(lock_service) do
    it { should be_enabled }
    it { should be_running }
  end

  describe service(idmap_service) do
    it { should be_enabled }
    it { should be_running }
  end
end

shared_examples_for 'nfs::service-client' do |node|
  it_behaves_like 'nfs::config-base', node

  describe service('nfs') do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end

shared_examples_for 'nfs::service-server' do |node|
  it_behaves_like 'nfs::config-base', node

  describe service('nfs') do
    it { should be_enabled }
    it { should be_running }
  end
end
