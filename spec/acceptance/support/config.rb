shared_examples_for 'nfs::config-client' do |node|
  describe file('/etc/sysconfig/nfs') do
    its(:content) { should match /^LOCKD_TCPPORT=32803$/ }
    its(:content) { should match /^LOCKD_UDPPORT=32769$/ }
  end

  describe file('/etc/idmapd.conf') do
    its(:content) { should match /^Domain = #{fact('domain')}$/ }
  end
end

shared_examples_for 'nfs::config-server' do |node|
  describe file('/etc/sysconfig/nfs') do
    its(:content) { should match /^LOCKD_TCPPORT=32803$/ }
    its(:content) { should match /^LOCKD_UDPPORT=32769$/ }
    its(:content) { should match /^RQUOTAD_PORT=875$/ }
    its(:content) { should match /^MOUNTD_PORT=892$/ }
    its(:content) { should match /^RPCNFSDCOUNT=8$/ }
  end

  describe file('/etc/idmapd.conf') do
    its(:content) { should match /^Domain = #{fact('domain')}$/ }
  end
end
