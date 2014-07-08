shared_context :defaults do
  let :default_facts do
    {
      :domain                     => 'example.com',
      :kernel                     => 'Linux',
      :osfamily                   => 'RedHat',
      :operatingsystem            => 'CentOS',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
      :architecture               => 'x86_64',
    }
  end
end
