class kernelcare::install {
  package {$kernelcare::package_name:
    ensure => $kernelcare::package_ensure,
  }
}
