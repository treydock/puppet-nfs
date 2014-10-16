require 'puppet'
require 'puppet/type/idmapd_config'
describe 'Puppet::Type.type(:idmapd_config)' do
  before :each do
    @idmapd_config = Puppet::Type.type(:idmapd_config).new(:name => 'vars/foo', :value => 'bar')
  end
  it 'should require a name' do
    expect {
      Puppet::Type.type(:idmapd_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:idmapd_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Invalid idmapd_config/)
  end
  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:idmapd_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Invalid idmapd_config/)
  end
  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:idmapd_config).new(:name => 'vars/foo', :ensure => :absent)
  end
  it 'should require a value when ensure is present' do
    expect {
      Puppet::Type.type(:idmapd_config).new(:name => 'vars/foo', :ensure => :present)
    }.to raise_error(Puppet::Error, /Property value must be set/)
  end
  it 'should accept a valid value' do
    @idmapd_config[:value] = 'bar'
    @idmapd_config[:value].should == 'bar'
  end
  it 'should not accept a value with whitespace' do
    @idmapd_config[:value] = 'b ar'
    @idmapd_config[:value].should == 'b ar'
  end
  it 'should accept valid ensure values' do
    @idmapd_config[:ensure] = :present
    @idmapd_config[:ensure].should == :present
    @idmapd_config[:ensure] = :absent
    @idmapd_config[:ensure].should == :absent
  end
  it 'should not accept invalid ensure values' do
    expect {
      @idmapd_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  describe 'autorequire File resources' do
    it 'should autorequire /etc/idmapd.conf' do
      conf = Puppet::Type.type(:file).new(:name => '/etc/idmapd.conf')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource @idmapd_config
      catalog.add_resource conf
      rel = @idmapd_config.autorequire[0]
      rel.source.ref.should == conf.ref
      rel.target.ref.should == @idmapd_config.ref
    end
  end
end
