require 'spec_helper_system'

describe 'nfs::server class:' do
  context 'should run successfully' do
    pp =<<-EOS
class { 'nfs::server': }
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

  describe service('nfs') do
    it { should be_enabled }
    # Running test will always fail unless Kerberos is configured before NFS
    it { should be_running.with_process_name('nfsd') }
  end
=begin
  describe command('service nfs status') do
    it { should return_exit_status 0 }
  end

  describe command('ps aux | grep -w -- nfsd | grep -qv grep') do
    it { should return_exit_status 0 }
  end
=end
end
