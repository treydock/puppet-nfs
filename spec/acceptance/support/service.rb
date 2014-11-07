shared_examples_for 'nfs::service-client' do |node|
  describe service('netfs') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('rpcbind') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('nfslock') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('rpcidmapd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('nfs') do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end

shared_examples_for 'nfs::service-server' do |node|
  describe service('netfs') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('rpcbind') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('nfslock') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('rpcidmapd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('nfs') do
    it { should be_enabled }
    it { should be_running }
  end
end
