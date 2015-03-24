shared_examples 'nfs::resources' do |facts|
  context "when nfsmount_configs is a Hash" do
    let :params do
      {
        :nfsmount_configs => {'NFSMount_Global_Options/Retrans' => {'value' => 2}}
      }
    end

    it { should have_nfsmount_config_resource_count(1) }

    it { should contain_nfsmount_config('NFSMount_Global_Options/Retrans').with_value('2') }
  end

  context 'with nfs_mounts defined' do
    let :params do
      {
        :nfs_mounts => {
          'foo' => {
            'device'  => '192.168.1.1:/foo',
            'path'    => '/foo',
            'options' => 'rw,nfsvers=3',
          },
        }
      }
    end

    it { should contain_nfs__mount('foo') }
  end
end
