# @summary Defines the OS params
#
# All defined params for different OS types
#
class twit_motd::params {
  case $facts['os']['family'] {
    'FreeBSD': {
      $root_group             = 'wheel'
      $root_user              = 'root'
      $motd_template          = "${module_name}/motd_text.epp"
      $motd_customer_template = "${module_name}/motd_custom_text.erb"
      if versioncmp($facts['os']['release']['major'], '13') >= 0 {
        $motd_file            = '/etc/motd.template'
      }
      else {
        $motd_file            = '/etc/motd'
      }
    }

    'Debian': {
      $root_group             = 'root'
      $root_user              = 'root'
      $motd_file              = '/etc/motd'
      $motd_template          = "${module_name}/motd_text.epp"
      $motd_customer_template = "${module_name}/motd_custom_text.erb"
    }

    default: {
      fail("|--------> Module ${module_name} is not supported on OS family ${facts['os']['family']} <--------|")
    }
  }
}
