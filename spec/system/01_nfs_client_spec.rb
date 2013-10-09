require 'spec_helper_system'

describe 'nfs::client class:' do
  context 'should run successfully' do
    pp =<<-EOS
class { 'nfs::client': }
    EOS
  
    context puppet_apply(pp) do
       its(:stderr) { should be_empty }
       its(:exit_code) { should_not == 1 }
       its(:refresh) { should be_nil }
       its(:stderr) { should be_empty }
       its(:exit_code) { should be_zero }
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
