class kernelcare::install {
  package {$kernelcare::package_name:
    ensure => pick($kernelcare::ensure, $kernelcare::package_ensure),
  }
}
