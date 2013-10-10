def server_default_firewall_resources
  [
    {:name => 'nfs', :number => ['105','106'], :port => '2049'},
    {:name => 'rquotad', :number => ['107','108'], :port => '875'},
    {:name => 'mountd', :number => ['109','110'], :port => '892'},
  ]
end

def rdma_firewall_resources
  [
    {:name => 'nfs rdma', :number => ['111','112'], :port => '20049'},
  ]
end

shared_examples "nfs::server firewall" do

  context "with manage_firewall => true" do
    let(:params) { default_params.merge({ :manage_firewall => true }) }

    it { should have_firewall_resource_count(10) }

    server_default_firewall_resources.each do |firewall|
      it do
        should contain_firewall("#{firewall[:number][0]} #{firewall[:name]} tcp").with({
          'ensure'  => 'present',
          'action'  => 'accept',
          'dport'   => (firewall[:port].is_a?(Array) ? firewall[:port][0] : firewall[:port]),
          'chain'   => 'INPUT',
          'proto'   => 'tcp',
        })
      end

      it do
        should contain_firewall("#{firewall[:number][1]} #{firewall[:name]} udp").with({
          'ensure'  => 'present',
          'action'  => 'accept',
          'dport'   => (firewall[:port].is_a?(Array) ? firewall[:port][1] : firewall[:port]),
          'chain'   => 'INPUT',
          'proto'   => 'udp',
        })
      end
    end

    context "with with_rdma => true" do
      let(:params) { default_params.merge({ :manage_firewall => true, :with_rdma => true }) }

      it { should have_firewall_resource_count(12) }

      rdma_firewall_resources.each do |firewall|
        it do
          should contain_firewall("#{firewall[:number][0]} #{firewall[:name]} tcp").with({
            'ensure'  => 'present',
            'action'  => 'accept',
            'dport'   => (firewall[:port].is_a?(Array) ? firewall[:port][0] : firewall[:port]),
            'chain'   => 'INPUT',
            'proto'   => 'tcp',
          })
        end

        it do
          should contain_firewall("#{firewall[:number][1]} #{firewall[:name]} udp").with({
            'ensure'  => 'present',
            'action'  => 'accept',
            'dport'   => (firewall[:port].is_a?(Array) ? firewall[:port][1] : firewall[:port]),
            'chain'   => 'INPUT',
            'proto'   => 'udp',
          })
        end
      end
    end
  end

  context "with manage_firewall => false" do
    let(:params) { default_params.merge({ :manage_firewall => false }) }

    it { should have_firewall_resource_count(4) }

    server_default_firewall_resources.each do |firewall|
      it { should_not contain_firewall("#{firewall[:number][0]} #{firewall[:name]} tcp") }

      it { should_not contain_firewall("#{firewall[:number][1]} #{firewall[:name]} udp") }
    end

    context "with nfs::client::manage_firewall => false" do
      let(:pre_condition) do
        "class { 'nfs::client': manage_firewall => false }"
      end

      it { should have_firewall_resource_count(0) }
    end
  end
end
