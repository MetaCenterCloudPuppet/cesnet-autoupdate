# == Class autoupdate::cron_apt
#
# Setup Debian cron-apt tool.
#
class autoupdate::cron_apt {
  $action = $autoupdate::action
  $email = $autoupdate::email

  ensure_packages($::autoupdate::packages)

  file { '/etc/cron-apt/config':
    content => template('autoupdate/cron-apt.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$autoupdate::packages],
  }
  file { '/etc/cron-apt/action.d/3-download':
    content => template('autoupdate/cron-apt-action-download.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$autoupdate::packages],
  }
  file { '/etc/cron-apt/action.d/9-upgrade':
    content => template('autoupdate/cron-apt-action-upgrade.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$autoupdate::packages],
  }
  file { '/etc/cron.d/cron-apt':
    ensure => absent,
  }
  cron { 'cron-apt autoupdate':
    command  => 'test -x /usr/sbin/cron-apt && /usr/sbin/cron-apt',
    hour     => $autoupdate::hour,
    minute   => $autoupdate::minute,
    month    => $autoupdate::month,
    monthday => $autoupdate::monthday,
    weekday  => $autoupdate::weekday,
    special  => $autoupdate::special,
  }
}
