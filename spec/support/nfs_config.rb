shared_examples 'nfs::config' do |facts|
  case facts[:operatingsystemmajrelease]
  when '7'
    idmapd_notify = false
  when '6'
    idmapd_notify = true
  when '5'
    idmapd_notify = true
  end

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
    should contain_file('/etc/nfsmount.conf').with({
      :ensure => 'file',
      :path   => '/etc/nfsmount.conf',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  it do
    should contain_file('/etc/idmapd.conf').with({
      :ensure => 'file',
      :path   => '/etc/idmapd.conf',
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

  it do
    should contain_shellvar('STATD_PORT').with({
      :ensure => 'present',
      :target => '/etc/sysconfig/nfs',
      :notify => 'Service[nfslock]',
      :value  => '662',
    })
  end

  it { should_not contain_shellvar('RQUOTAD_PORT') }
  it { should_not contain_shellvar('MOUNTD_PORT') }
  it { should_not contain_shellvar('RPCNFSDCOUNT') }
  it { should_not contain_shellvar('RPCNFSDARGS') }
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
    end
  end


  it do
    should contain_idmapd_config('General/Domain').with({
      :value  => 'example.com',
    })
  end

  it do
    if idmapd_notify
      should contain_idmapd_config('General/Domain').with_notify('Service[rpcidmapd]')
    else
      should contain_idmapd_config('General/Domain').without_notify
    end
  end

  it { should_not contain_sysctl('fs.nfs.nfs_callback_tcpport') }

  context 'when enable_idmapd => false' do
    let(:params) {{ :enable_idmapd => false }}

    it 'idmapd_config should not notify' do
      should contain_idmapd_config('General/Domain').without_notify
    end
  end

  context 'when nfs_callback_tcpport => 62049' do
    let(:params) {{ :nfs_callback_tcpport => '62049' }}

    it do
      should contain_sysctl('fs.nfs.nfs_callback_tcpport').with({
        :value => '62049',
      })
    end
  end

  context 'when configure_ports => false' do
    let(:params) {{ :configure_ports => false }}

    it { should_not contain_shellvar('LOCKD_TCPPORT') }
    it { should_not contain_shellvar('LOCKD_UDPPORT') }
    it { should_not contain_shellvar('STATD_PORT') }
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

    it { should_not contain_shellvar('RPCNFSDARGS') }
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

    context 'with rpc_nfsd_args => "-N 4"' do
      let(:params) {{ :server => true, :rpc_nfsd_args => '-N 4' }}

      it do
        should contain_shellvar('RPCNFSDARGS').with({
          :ensure => 'present',
          :target => '/etc/sysconfig/nfs',
          :notify => ['Service[nfslock]', 'Service[nfs]'],
          :value  => '-N 4',
        })
      end
    end

    context 'when configure_ports => false' do
      let(:params) {{ :server => true, :configure_ports => false }}

      it { should_not contain_shellvar('RQUOTAD_PORT') }
      it { should_not contain_shellvar('MOUNTD_PORT') }
    end
  end
end
