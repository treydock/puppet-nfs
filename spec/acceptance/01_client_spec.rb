require 'spec_helper_acceptance'

describe 'nfs client:' do
  node = only_host_with_role(hosts, 'client')

  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'nfs': }
      EOS
  
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'nfs::install', node
    it_behaves_like 'nfs::config-client', node
    it_behaves_like 'nfs::service-client', node
  end

  context "with nfsmount_configs set" do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'nfs':
        nfsmount_configs => {'NFSMount_Global_Options/Nfsvers' => {'value' => 3}}
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/nfsmount.conf') do
      its(:content) { should match /^Nfsvers=3$/ }
    end
  end
end
