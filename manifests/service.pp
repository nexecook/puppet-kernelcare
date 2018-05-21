class kernelcare::service {
  if $kernelcare::service_manage and $kernelcare::ensure != 'absent' {
    service {$kernelcare::service_name:
      ensure => $kernelcare::service_ensure,
    }
  }
}
