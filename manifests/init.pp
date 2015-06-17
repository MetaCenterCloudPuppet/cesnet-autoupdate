# == Class: autoupdate
#
# The main autoupdate class.
#
# === Parameters
#
# ####`email`
# Email to sent notifications. Default is undef.
#
# ####`randomwait`
# Random time to wait before update in seconds. Default is 3600.
#
# ####`type`
# Update type. Default is 'default'.
#
# * *cron-apt*: **default**, **dist**
# * *yum\_autoupdate*: **default**, **security**, **minimal**, ...
#
# ####`hour`
# ####`minute`
# ####`month`
# ####`monthday`
# ####`weekday`
# ####`special`
# Parameters for cron job.
#
class autoupdate(
  $email = undef,
  $randomwait = 3600,
  $type = 'default',

  $hour = 5,
  $minute = absent,
  $month = absent,
  $monthday = absent,
  $weekday = absent,
  $special = absent,
) inherits ::autoupdate::params {
  include stdlib

  validate_string($type)

  case $::osfamily {
    'Debian': {
      $action = $type ? {
        /dist(-upgrade)?/ => 'dist-upgrade',
        default           => 'upgrade',
      }
      include autoupdate::cron_apt
    }
    'RedHat': {
      $notify = $email ? {
        undef   => false,
        default => true,
      }
      class{'yum_autoupdate':
        default_schedule => false,
      }
      yum_autoupdate::schedule { 'autoupdate':
        email_to     => $email,
        notify_email => $notify,
        update_cmd   => $type,
        randomwait   => $randomwait / 60,
        hour         => $hour,
        minute       => $minute,
        month        => $month,
        monthday     => $monthday,
        weekday      => $weekday,
        special      => $special,
      }
    }
    default: {
      fail("${::osfamily}/${::operatingsystem} not supported")
    }
  }
}
