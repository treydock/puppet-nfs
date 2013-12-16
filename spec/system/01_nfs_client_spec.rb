require 'spec_helper_system'

describe 'nfs::client class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
  class { 'nfs::client': }
      EOS
  
      puppet_apply(pp) do |r|
       r.exit_code.should_not == 1
       r.refresh
       r.exit_code.should be_zero
      end
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
