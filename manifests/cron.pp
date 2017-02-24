class kernelcare::cron {

  if $kernelcare::cron_install {
    file {'/etc/cron.d/kcare-cron':
      ensure => 'absent',
    }

    cron {'kernelcare':
      command  => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /usr/bin/kcarectl --auto-update >/dev/null 2>&1',
      minute   => $kernelcare::cron_minute,
      hour     => $kernelcare::cron_hour,
      month    => $kernelcare::cron_month,
      monthday => $kernelcare::cron_monthday,
      weekday  => $kernelcare::cron_weekday,
    }
  }
}
