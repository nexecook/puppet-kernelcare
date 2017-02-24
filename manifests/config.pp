class kernelcare::config {
  file {'/etc/sysconfig/kcare/kcare.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template($kernelcare::config_template_kcare),
  }

  file {'/etc/sysconfig/kcare/freezer.modules.blacklist':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template($kernelcare::config_template_kmod_blacklist),
  }

  if $kernelcare::config_managekey {
    kernelcare_register {$kernelcare::config_accesskey:
      ensure => $kernelcare::config_ensurekey
    }
  }
}
