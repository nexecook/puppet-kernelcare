class kernelcare::repo {
  if $kernelcare::repo_install {
    case $::operatingsystem {
      'CentOS', 'RedHat': {
        yumrepo {$kernelcare::repo_name:
          baseurl  => "${kernelcare::repo_yum_baseurl_prefix}/\$releasever/\$basearch/",
          descr    => $kernelcare::repo_descr,
          enabled  => bool2num($kernelcare::repo_enabled),
          gpgcheck => bool2num($kernelcare::repo_gpgcheck),
          gpgkey   => $kernelcare::repo_gpgkey,
        }
      }
      'Debian', 'Ubuntu': {
        include ::apt
        apt::source {$kernelcare::repo_name:
          location => $kernelcare::repo_apt_location,
          repos    => $kernelcare::repo_name,
          key      => {
            'id'     => $kernelcare::repo_key_id,
            'source' => $kernelcare::repo_key_source,
          }
        }
        Class['apt::update'] -> Class['kernelcare::install']
      }
      default: {
        fail("${::operatingsystem} not supported")
      }
    }
  }
}
