require 'spec_helper_acceptance'

describe 'nfs::server class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'nfs::server': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
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

    describe service('nfs') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
