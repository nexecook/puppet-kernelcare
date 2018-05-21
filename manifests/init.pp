class kernelcare (

  Variant[Undef,Enum['absent','uninstalled']] $ensure = $kernelcare::params::ensure,

  $config_ensure                     = $kernelcare::params::config_ensure,
  $config_template_kcare             = $kernelcare::params::config_template_kcare,
  $config_template_kmod_blacklist    = $kernelcare::params::config_template_kmod_blacklist,
  $config_kmod_blacklist             = $kernelcare::params::config_kmod_blacklist,
  $config_managekey                  = $kernelcare::params::config_managekey,
  $config_accesskey                  = $kernelcare::params::config_accesskey,
  $config_ensurekey                  = $kernelcare::params::config_ensurekey,
  $config_autoupdate                 = $kernelcare::params::config_autoupdate,

  $cron_manage                       = $kernelcare::params::cron_manage,
  $cron_ensure                       = $kernelcare::params::cron_ensure,
  $cron_minute                       = $kernelcare::params::cron_minute,
  $cron_hour                         = $kernelcare::params::cron_hour,
  $cron_month                        = $kernelcare::params::cron_month,
  $cron_monthday                     = $kernelcare::params::cron_monthday,
  $cron_weekday                      = $kernelcare::params::cron_weekday,

  $repo_install                      = $kernelcare::params::repo_install,
  $repo_name                         = $kernelcare::params::repo_name,
  $repo_descr                        = $kernelcare::params::repo_descr,
  $repo_yum_baseurl_prefix           = $kernelcare::params::repo_yum_baseurl_prefix,
  $repo_apt_location                 = $kernelcare::params::repo_apt_location,
  $repo_apt_release                  = $kernelcare::params::repo_apt_release,
  $repo_apt_repos                    = $kernelcare::params::repo_apt_repos,
  $repo_enabled                      = $kernelcare::params::repo_enabled,
  $repo_gpgcheck                     = $kernelcare::params::repo_gpgcheck,
  $repo_gpgkey                       = $kernelcare::params::repo_gpgkey,
  $repo_key_id                       = $kernelcare::params::repo_key_id,
  $repo_key_source                   = $kernelcare::params::repo_key_source,

  $package_name                      = $kernelcare::params::package_name,
  $package_ensure                    = $kernelcare::params::package_ensure,

  $service_manage                    = $kernelcare::params::service_manage,
  $service_name                      = $kernelcare::params::service_name,
  $service_ensure                    = $kernelcare::params::service_ensure,

  ) inherits kernelcare::params {
    validate_string($config_ensure)
    validate_string($config_template_kcare)
    validate_string($config_template_kmod_blacklist)
    validate_array($config_kmod_blacklist)
    validate_string($config_accesskey)
    validate_bool($config_managekey)
    validate_string($config_ensurekey)
    validate_bool($config_autoupdate)

    validate_bool($cron_manage)
    validate_string($cron_ensure)

    validate_bool($repo_install)
    validate_string($repo_name)
    validate_string($repo_descr)
    validate_string($repo_yum_baseurl_prefix)
    validate_string($repo_apt_location)
    validate_bool($repo_enabled)
    validate_bool($repo_gpgcheck)
    validate_string($repo_gpgkey)
    validate_string($repo_key_id)
    validate_string($repo_key_source)

    validate_string($package_name)
    validate_string($package_ensure)

    validate_bool($service_manage)
    validate_string($service_name)
    validate_string($service_ensure)

    anchor {'kernelcare::begin':}
    -> class{'::kernelcare::repo':}
    -> class{'::kernelcare::install':}
    -> class{'::kernelcare::config':}
    -> class{'::kernelcare::service':}
    -> class{'::kernelcare::cron':}
    -> anchor {'kernelcare::end':}
}
