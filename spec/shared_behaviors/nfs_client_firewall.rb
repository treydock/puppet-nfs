def client_default_firewall_resources
  [
    {:name => 'portmapper', :number => ['101','102'], :port => '111'},
    {:name => 'lockd', :number => ['103','104'], :port => ['32803','32769']},
  ]
end

shared_examples "nfs::client firewall" do

  context "with manage_firewall => true" do
    let(:params) { default_params.merge({ :manage_firewall => true }) }

    it { should have_firewall_resource_count(4) }

    client_default_firewall_resources.each do |firewall|
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

  context "with manage_firewall => false" do
    let(:params) { default_params.merge({ :manage_firewall => false }) }

    it { should have_firewall_resource_count(0) }

    client_default_firewall_resources.each do |firewall|
      it { should_not contain_firewall("#{firewall[:number][0]} #{firewall[:name]} tcp") }

      it { should_not contain_firewall("#{firewall[:number][1]} #{firewall[:name]} udp") }
    end
  end
end
