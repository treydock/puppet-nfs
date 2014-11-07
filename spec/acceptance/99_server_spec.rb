require 'spec_helper_acceptance'

describe 'nfs server:' do
  node = only_host_with_role(hosts, 'server')

  context 'with default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'nfs': server => true }
      EOS
  
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'nfs::install', node
    it_behaves_like 'nfs::config-server', node
    it_behaves_like 'nfs::service-server', node
  end
end
