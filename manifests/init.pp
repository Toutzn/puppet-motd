# @summary Setup dedicated motd to setup motd.
# This module can be use in all other modules to announce the module usage in motd
#
# @param motd_mailcontact
#   Specify the email address as contact in motd
#
# @param motd_motd
#   A string of a custom motd message
#
class twit_motd (
  Stdlib::Email       $motd_mailcontact = 'your@e-mail.ltd',
  Optional[String[1]] $motd_motd        = undef,
) {
  contain twit_motd::params
  contain twit_motd::config

  Class['twit_motd::params']
  -> Class['twit_motd::config']

  twit_motd::register { $module_name: }
}
