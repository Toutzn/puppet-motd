# @summary Register a motd message into motd.
# This register can be used from modules to put a message into the motd
#
# @param content
#   String of a message
# @param order
#   Define the position of the message
#
define twit_motd::register (
  String $content = '',
  String $order   = '10',
) {
  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }

  concat::fragment { "motd_fragment_${name}":
    target  => $twit_motd::params::motd_file,
    order   => $order,
    content => "      -- ${body}\n",
  }
}
