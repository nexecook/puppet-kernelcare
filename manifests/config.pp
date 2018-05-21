class kernelcare::config {
  $ensure = pick($kernelcare::ensure, $kernelcare::config_ensure)

  file {'/etc/sysconfig/kcare/kcare.conf':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template($kernelcare::config_template_kcare),
  }

  file {'/etc/sysconfig/kcare/freezer.modules.blacklist':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template($kernelcare::config_template_kmod_blacklist),
  }

  if $kernelcare::config_managekey and $kernelcare::ensure != 'absent' {
    kernelcare_register {$kernelcare::config_accesskey:
      ensure => $kernelcare::config_ensurekey
    }
  }
}
