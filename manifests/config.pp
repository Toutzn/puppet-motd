# @summary Configure the motd
#
# Creates configuration for this service / function
#
# @api private
#
class twit_motd::config {
  assert_private()

  include twit_motd::notify

  $_motd_contact           = $twit_motd::motd_mailcontact

  $_motd_file              = $twit_motd::params::motd_file
  $_motd_template          = $twit_motd::params::motd_template
  $_motd_customer_template = $twit_motd::params::motd_customer_template
  $_root_user              = $twit_motd::params::root_user
  $_root_group             = $twit_motd::params::root_group

  concat { $_motd_file:
    ensure => present,
    owner  => $_root_user,
    group  => $_root_group,
    mode   => '0644',
    notify => Class['twit_motd::notify'],
  }

  -> concat::fragment { 'motd_header':
    target  => $_motd_file,
    order   => '01',
    content => epp($_motd_template,
      {
        mail_contact => $_motd_contact,
      }
    ),
  }

  -> concat::fragment { 'motd_registered_modules':
    target  => $_motd_file,
    content => "    Registered puppet modules:\n",
    order   => '09',
  }

  # twit_motd::register will be ordered by 10

  -> concat::fragment { 'motd_footer':
    target  => $_motd_file,
    content => template($_motd_customer_template),
    order   => '15',
  }
}
