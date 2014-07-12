require 'spec_helper_acceptance'

describe 'nfsmount_config type' do
  context 'set NFSMount_Global_Options/Defaultvers' do
    it 'should run successfully' do
      pp =<<-EOS
      nfsmount_config { 'NFSMount_Global_Options/Defaultvers': value => '3' }
      EOS
  
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/nfsmount.conf') do
      its(:content) { should match /^Defaultvers=3$/ }
    end
  end
end
