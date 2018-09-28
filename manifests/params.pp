class kernelcare::params {
  $config_template_kcare          = 'kernelcare/kcare.conf.erb'
  $config_template_kmod_blacklist = 'kernelcare/freezer.modules.blacklist.erb'
  $config_kmod_blacklist          = ['vxodm', 'vxportal', 'vxfen', 'vxspec', 'vxio']

  $ensure                         = undef
  $config_ensure                  = 'present'
  $config_accesskey               = 'INSERT_ACCESS_KEY'
  $config_managekey               = false
  $config_ensurekey               = 'present'
  $config_autoupdate              = true
  $config_kcareconf_hash          = {}

  $cron_manage                    = true
  $cron_ensure                    = 'present'
  $cron_minute                    = [fqdn_rand(30) , fqdn_rand(30) + 30]
  $cron_hour                      = '*'
  $cron_month                     = '*'
  $cron_monthday                  = '*'
  $cron_weekday                   = '*'

  $repo_install                   = true
  $repo_name                      = 'kernelcare'
  $repo_descr                     = 'kernelcare'
  $repo_yum_baseurl_prefix        = 'https://repo.cloudlinux.com/kernelcare'
  $repo_apt_location              = 'https://repo.cloudlinux.com/kernelcare-debian/8'
  $repo_apt_release               = 'stable'
  $repo_apt_repos                 = 'main'
  $repo_enabled                   = true
  $repo_gpgcheck                  = true
  $repo_gpgkey                    = 'https://repo.cloudlinux.com/kernelcare/RPM-GPG-KEY-KernelCare'
  $repo_key_id                    = '6DC3D600CDEF74BB'
  $repo_key_source                = 'https://repo.cloudlinux.com/kernelcare-debian/8/conf/kcaredsa_pub.gpg'

  $package_name                   = 'kernelcare'
  $package_ensure                 = 'present'

  $service_manage                 = true
  $service_name                   = 'kcare'
  $service_ensure                 = 'running'
}
