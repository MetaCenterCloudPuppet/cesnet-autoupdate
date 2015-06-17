# == Class: autoupdate::params
#
# This class is meant to be called from autoupdate.
# It sets variables according to platform.
#
class autoupdate::params {
  case $::osfamily {
    'Debian': {
      $packages = 'cron-apt'
    }
    default: {
      $packages = undef
    }
  }
}
