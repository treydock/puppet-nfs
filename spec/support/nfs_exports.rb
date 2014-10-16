shared_examples 'nfs::exports' do
  it { should_not contain_file('/etc/exports') }
  it { should_not contain_exec('exportfs') }

  context 'when server => true' do
    let(:params) {{ :server => true }}

    it do
      should contain_file('/etc/exports').with({
        :ensure => 'file',
        :path   => '/etc/exports',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
        :notify => 'Exec[exportfs]',
      })
    end

    it do
      should contain_exec('exportfs').with({
        :path         => 'sbin:/bin:/usr/sbin:/usr/bin',
        :command      => 'exportfs -r',
        :refreshonly  => 'true',
      })
    end
    context 'with exports defined' do
      let :params do
        {
          :server  => true,
          :exports => {
            '/mnt/ab' => [
              {
                'host'    => '192.168.1.0/24',
                'options' => 'ro,sync',
                'order'   => '2',
              },
              {
                'host'    => '192.168.1.1',
                'options' => 'rw,sync,no_root_squash',
                'order'   => '1',
              }
            ],
            '/mnt/abc' => [
              {
                'host'    => '192.168.1.2',
                'options' => 'rw,async,no_root_squash',
              }
            ],
            '/mnt/foobar' => [
              {
                'host'    => '192.168.1.2',
                'options' => 'rw,async',
              }
            ]
          }
        }
      end

      it do
        verify_contents(catalogue, '/etc/exports', [
          '/mnt/ab      192.168.1.1(rw,sync,no_root_squash) 192.168.1.0/24(ro,sync)',
          '/mnt/abc     192.168.1.2(rw,async,no_root_squash)',
          '/mnt/foobar  192.168.1.2(rw,async)',
        ])
      end
    end

    context 'with exports defined without order' do
      let :params do
        {
          :server  => true,
          :exports => {
            '/mnt/ab' => [
              {
                'host'    => '192.168.1.2',
                'options' => 'ro,sync',
              },
              {
                'host'    => '192.168.1.1',
                'options' => 'rw,sync,no_root_squash',
              },
              {
                'host'    => '192.168.1.0/24',
                'options' => 'rw,async,no_root_squash',
              }
            ]
          }
        }
      end

      it do
        verify_contents(catalogue, '/etc/exports', [
          '/mnt/ab  192.168.1.0/24(rw,async,no_root_squash) 192.168.1.1(rw,sync,no_root_squash) 192.168.1.2(ro,sync)',
        ])
      end
    end
  end

end
