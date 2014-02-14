require 'spec_helper_acceptance'

describe 'nfs::client class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
  class { 'nfs::client': }
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
  end
end
