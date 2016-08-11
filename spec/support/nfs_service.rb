shared_examples 'nfs::service' do |facts|
  case facts[:operatingsystemmajrelease]
  when '7'
    idmapd          = false
    lock_service    = 'rpc-statd'
    rpc_service     = 'rpcbind'
    idmap_service   = 'nfs-idmapd'
    server_service  = 'nfs-server'
  when '6'
    idmapd          = true
    lock_service    = 'nfslock'
    rpc_service     = 'rpcbind'
    idmap_service   = 'rpcidmapd'
    server_service  = 'nfs'
  when '5'
    idmapd          = true
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

  if idmapd
    it do
      should contain_service('rpcidmapd').with({
        :ensure      => 'running',
        :enable      => 'true',
        :hasstatus   => 'true',
        :hasrestart  => 'true',
        :name        => idmap_service,
      })
    end
  else
    it do
      should contain_service('rpcidmapd').with({
        :ensure      => 'stopped',
        :enable      => 'false',
        :hasstatus   => 'true',
        :hasrestart  => 'true',
        :name        => idmap_service,
      })
    end
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

  context 'when manage_rpcbind => false' do
    let(:params) {{ :manage_rpcbind => false }}

    it 'should not manage rpcbind service' do
      should_not contain_service('rpcbind')
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

    it do
      should contain_service('rpcidmapd').with({
        :ensure      => 'running',
        :enable      => 'true',
        :hasstatus   => 'true',
        :hasrestart  => 'true',
        :name        => idmap_service,
      })
    end

    context 'with service_autorestart => false' do
      let(:params) {{ :server => true, :server_service_autorestart => false }}
      it { should contain_service('nfs').without_subscribe }
    end
  end
end
