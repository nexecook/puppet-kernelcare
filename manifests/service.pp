class kernelcare::service {
  if $kernelcare::service_manage {
    service {$kernelcare::service_name:
      ensure => $kernelcare::service_ensure,
    }
  }
}
