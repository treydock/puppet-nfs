shared_examples 'nfs::config' do
  it do
    should contain_file('/etc/sysconfig/nfs').with({
      :ensure => 'file',
      :path   => '/etc/sysconfig/nfs',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  it do
    should contain_shellvar('LOCKD_TCPPORT').with({
      :ensure => 'present',
      :target => '/etc/sysconfig/nfs',
      :notify => 'Service[nfslock]',
      :value  => '32803',
    })
  end

  it do
    should contain_shellvar('LOCKD_UDPPORT').with({
      :ensure => 'present',
      :target => '/etc/sysconfig/nfs',
      :notify => 'Service[nfslock]',
      :value  => '32769',
    })
  end

  it { should_not contain_shellvar('RQUOTAD_PORT') }
  it { should_not contain_shellvar('MOUNTD_PORT') }
  it { should_not contain_shellvar('RPCNFSDCOUNT') }
  it { should_not contain_shellvar('RDMA_PORT') }

  it { should have_nfsmount_config_resource_count(0) }

  [
    'defaultvers',
    'nfsvers',
    'defaultproto',
    'proto',
    'soft',
    'lock',
    'rsize',
    'wsize',
    'sharecache',
  ].each do |p|
    context "when global_#{p} => 'FOO'" do
      let(:params) {{ :"global_#{p}" => 'FOO' }}
      let(:setting) { p.capitalize }
      it { should have_nfsmount_config_resource_count(1) }
      it { should contain_nfsmount_config("NFSMount_Global_Options/#{setting}").with_value('FOO') }
      it { should contain_package('nfs').that_comes_before("Nfsmount_config[NFSMount_Global_Options/#{setting}]") }
    end
  end


  it do
    should contain_idmapd_config('General/Domain').with({
      :value  => 'example.com',
      :notify => 'Service[rpcidmapd]',
    })
  end

  context 'when server => true' do
    let(:params) {{ :server => true }}

    it do
      should contain_shellvar('RQUOTAD_PORT').with({
        :ensure => 'present',
        :target => '/etc/sysconfig/nfs',
        :notify => ['Service[nfslock]','Service[nfs]'],
        :value  => '875',
      })
    end

    it do
      should contain_shellvar('MOUNTD_PORT').with({
        :ensure  => 'present',
        :target  => '/etc/sysconfig/nfs',
        :notify => ['Service[nfslock]','Service[nfs]'],
        :value   => '892',
      })
    end

    it do
      should contain_shellvar('RPCNFSDCOUNT').with({
        :ensure  => 'present',
        :target  => '/etc/sysconfig/nfs',
        :notify => ['Service[nfslock]','Service[nfs]'],
        :value   => '8',
      })
    end

    it { should_not contain_shellvar('RDMA_PORT') }

    context "with rpc_nfsd_count => 16" do
      let(:params) {{ :server => true, :rpc_nfsd_count => 16 }}
      it { should contain_shellvar('RPCNFSDCOUNT').with_value('16') }
    end

    context "with rpc_nfsd_count => 16" do
      let(:params) {{ :server => true, :with_rdma => true }}

      it do
        should contain_shellvar('RDMA_PORT').with({
          :ensure  => 'present',
          :target  => '/etc/sysconfig/nfs',
          :notify => ['Service[nfslock]','Service[nfs]'],
          :value   => '20049',
        })
      end
    end
  end
end