Puppet::Type.type(:kernelcare_register).provide(:kcarectl) do
  desc 'Register an kernelcare license using the kcarectl command'

  def create
    notice "Registering the license #{resource[:license]}"
    %x{/usr/bin/kcarectl --register "#{resource[:license]}"}
  end

  def destroy
    notice "Removing the license"
    %x{/usr/bin/kcarectl --unregister}
  end

  def exists?
    # Currently not aware of an deterministic way of knowing the 
    # contents of the file. So if a license change is required,
    # delete the systemid file before running the module.
    File.exists?('/etc/sysconfig/kcare/systemid')
  end
end
