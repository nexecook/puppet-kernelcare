if File.exist?('/usr/bin/kcare-uname')
  Facter.add(:kernelcare_kernelrelease) do
    setcode do
      Facter::Util::Resolution.exec('/usr/bin/kcare-uname -r 2>/dev/null')
    end
  end

  Facter.add(:kernelcare_kernelversion) do
    setcode do
      Facter.value(:kernelcare_kernelrelease).split('-')[0]
    end
  end

  Facter.add(:kernelcare_kernelmajversion) do
    setcode do
      Facter.value(:kernelcare_kernelversion).split('.')[0..1].join('.')
    end
  end
end
