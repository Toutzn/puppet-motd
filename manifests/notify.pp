# @summary Notifiy the motd service for specific OS
#
class twit_motd::notify {
  case $facts['os']['family'] {
    'FreeBSD': {
      if versioncmp($facts['os']['release']['major'], '13') >= 0 {
        exec { 'motd_reload':
          refreshonly => true,
          path        => ['/usr/bin','/usr/sbin','/bin','/sbin','/usr/local/bin','/usr/local/sbin'],
          command     => 'service motd onerestart',
        }
      }
    }

    default: {}
  }
}
