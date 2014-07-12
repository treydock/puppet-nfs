require 'spec_helper_acceptance'

describe 'nfs class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'nfs': }
      EOS
  
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('netfs') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('rpcbind') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('nfslock') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('rpcidmapd') do
      it { should be_enabled }
      it { should be_running }
    end

    describe service('nfs') do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe file('/etc/idmapd.conf') do
      its(:content) { should match /^Domain = #{fact('domain')}$/ }
    end
  end

  context 'when server => true' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'nfs': server => true }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('nfs') do
      it { should be_enabled }
      it { should be_running }
    end
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
