shared_examples 'nfs::service' do
  it do
    should contain_service('netfs').with({
      :ensure     => 'running',
      :enable     => 'true',
      :name       => 'netfs',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end

  it do
    should contain_service('rpcbind').with({
      :ensure     => 'running',
      :enable     => 'true',
      :name       => 'rpcbind',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end

  it { should contain_service('rpcbind').that_comes_before('Service[nfslock]') }

  it do
    should contain_service('nfslock').with({
      :ensure     => 'running',
      :enable     => 'true',
      :name       => 'nfslock',
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end

  it { should_not contain_service('nfs') }

  it do
    should contain_service('rpcidmapd').with({
      :ensure      => 'running',
      :enable      => 'true',
      :hasstatus   => 'true',
      :hasrestart  => 'true',
      :name        => 'rpcidmapd',
    })
  end

  context 'when enable_idmapd => false' do
    let(:params) {{ :enable_idmapd => false }}

    it 'rpcidmapd should be stopped and disabled' do
      should contain_service('rpcidmapd').with({
        :ensure => 'stopped',
        :enable => 'false',
      })
    end
  end

  context 'when server => true' do
    let(:params) {{ :server => true }}

    it do
      should contain_service('nfs').with({
        :ensure     => 'running',
        :enable     => 'true',
        :name       => 'nfs',
        :hasstatus  => 'true',
        :hasrestart => 'true',
        :subscribe  => 'File[/etc/sysconfig/nfs]',
        :require    => 'Service[nfslock]',
      })
    end

    it { should_not contain_service('nfs-rdma') }

    context 'with service_autorestart => false' do
      let(:params) {{ :server => true, :server_service_autorestart => false }}
      it { should contain_service('nfs').without_subscribe }
    end
  end
end
