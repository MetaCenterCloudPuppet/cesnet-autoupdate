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
# Random time to wait before update in seconds. Default is to leave it to the autoupdate tools (1 hour for cron-apt and yum-autoupdate).
#
# ####`update`
# Update type. Default is 'default'.
#
# * *cron-apt*: **default**, **dist**
# * *yum\_autoupdate*: **default**, **security**, **minimal**, ...
#
# Unknown types translates to **default**.
#
# ####`hour`
# ####`minute`
# ####`month`
# ####`monthday`
# ####`weekday`
# ####`special`
# Parameters for cron job. Beware the defaults are **\***!
#
class autoupdate(
  $email = undef,
  $randomwait = undef,
  $update = 'default',

  $hour = 5,
  $minute = absent,
  $month = absent,
  $monthday = absent,
  $weekday = absent,
  $special = absent,
) inherits ::autoupdate::params {
  include stdlib

  validate_string($update)

  case $::osfamily {
    'Debian': {
      $action = $update ? {
        /dist(-upgrade)?/ => 'dist-upgrade',
        default           => 'upgrade',
      }
      include autoupdate::cron_apt
    }
    'RedHat': {
      $action = $update ? {
        /dist(-upgrade)?/ => 'default',
        /upgrade/         => 'default',
        default           => $update,
      }
      $notify = $email ? {
        undef   => false,
        default => true,
      }
      case $randomwait {
        undef: {
          $randomwait_min = undef
        }
        default: {
          $randomwait_min = $randomwait / 60
        }
      }
      class{'yum_autoupdate':
        default_schedule => false,
      }
      yum_autoupdate::schedule { 'autoupdate':
        email_from   => "root@${::fqdn}",
        email_to     => $email,
        notify_email => $notify,
        update_cmd   => $action,
        randomwait   => $randomwait_min,
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
