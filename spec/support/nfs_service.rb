shared_examples 'nfs::service' do |facts|
  case facts[:operatingsystemmajrelease]
  when '7'
    lock_service    = 'nfs-lock'
    rpc_service     = 'rpcbind'
    idmap_service   = 'nfs-idmap'
    server_service  = 'nfs-server'
  when '6'
    lock_service    = 'nfslock'
    rpc_service     = 'rpcbind'
    idmap_service   = 'rpcidmapd'
    server_service  = 'nfs'
  when '5'
    lock_service    = 'nfslock'
    rpc_service     = 'portmap'
    idmap_service   = 'rpcidmapd'
    server_service  = 'nfs'
  end

  if facts[:operatingsystemmajrelease] < '7'
    it do
      should contain_service('netfs').with({
        :ensure     => 'running',
        :enable     => 'true',
        :name       => 'netfs',
        :hasstatus  => 'true',
        :hasrestart => 'true',
      })
    end
  end

  it do
    should contain_service('rpcbind').with({
      :ensure     => 'running',
      :enable     => 'true',
      :name       => rpc_service,
      :hasstatus  => 'true',
      :hasrestart => 'true',
    })
  end

  it { should contain_service('rpcbind').that_comes_before('Service[nfslock]') }

  it do
    should contain_service('nfslock').with({
      :ensure     => 'running',
      :enable     => 'true',
      :name       => lock_service,
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
      :name        => idmap_service,
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
        :name       => server_service,
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
