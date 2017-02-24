Puppet::Type.newtype(:kernelcare_register) do
  ensurable
  newparam(:license, :namevar => true) do
    desc "License used to register with kernelcare."
    munge do |value|
      value.chomp
    end
  end
end
