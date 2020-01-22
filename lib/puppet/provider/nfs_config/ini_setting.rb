Puppet::Type.type(:nfs_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  # The sections in nfsmount.conf have spaces around them like [ NFSMount_Global_Options ]
  def section
    " " + resource[:name].split('/', 2).first + " "
  end

  def setting
    resource[:name].split('/', 2).last
  end

  def separator
    '='
  end

  def self.file_path
    '/etc/nfs.conf'
  end
end
