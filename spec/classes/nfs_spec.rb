require 'spec_helper'

describe 'nfs' do
  on_supported_os({
    :hardwaremodels => ['x86_64'],
    :supported_os   => [
      {
        'operatingsystem' => 'CentOS',
        'operatingsystemrelease'  => [
          '5',
          '6',
          '7',
        ]
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { should create_class('nfs') }
      it { should contain_class('nfs::params') }

      it { should contain_anchor('nfs::start').that_comes_before('Class[nfs::install]') }
      it { should contain_class('nfs::install').that_comes_before('Class[nfs::config]') }
      it { should contain_class('nfs::config').that_comes_before('Class[nfs::service]') }
      it { should contain_class('nfs::service').that_comes_before('Class[nfs::firewall]') }
      it { should contain_class('nfs::firewall').that_comes_before('Class[nfs::exports]') }
      it { should contain_class('nfs::exports').that_comes_before('Class[nfs::resources]') }
      it { should contain_class('nfs::resources').that_comes_before('Anchor[nfs::end]') }
      it { should contain_anchor('nfs::end') }

      it_behaves_like 'nfs::install', facts
      it_behaves_like 'nfs::config', facts
      it_behaves_like 'nfs::service', facts
      it_behaves_like 'nfs::firewall', facts
      it_behaves_like 'nfs::exports', facts
      it_behaves_like 'nfs::resources', facts

      context 'validations' do
        # Test boolean validation
        [
          :server,
          :manage_firewall,
          :manage_rpcbind,
          :manage_idmapd,
          :enable_idmapd,
          :server_service_autorestart,
          :with_rdma,
        ].each do |param|
          context "with #{param} => 'foo'" do
            let(:params) {{ param => 'foo' }}
            it "should raise an error" do
              expect { should compile }.to raise_error(/is not a boolean/)
            end
          end
        end

        # Test hash validation
        [
          :nfs_mounts,
          :nfsmount_configs,
          :exports,
        ].each do |param|
          context "with #{param} => 'foo'" do
            let(:params) {{ param => 'foo' }}
            it "should raise an error" do
              expect { should compile }.to raise_error(/is not a Hash/)
            end
          end
        end
      end # end validations
    end
  end

end
