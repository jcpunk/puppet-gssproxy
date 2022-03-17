# @summary Create gssproxy a service definition
#
# This resource creates gssproxy service definitions.
# If you using your own management of the gssproxy system
# service, you will need to setup your own notifications.
# If you are using this module to manage the system service
# notifications should happen automatically.
#
# @param section
#   Name of the section within the config file.
#   It defaults to the resource title.
#
# @param filename
#   Name of the config file to write out.
#   The filename must start with two digits and a - (/^\d\d-/) or gssproxy will not see it.
#   The filename must end in `.conf` or gssproxy will not see it.
#
# @param order
#   gssproxy requires config files to start with a 2 digit number
#   and then a `-`.  So we permit just setting the number prefix.
#   Default: 50
#
# @param gssproxy_conf_d
#   Directory where we will write the new service config file.
#   Default: from the gssproxy main class
#
# @param settings
#   A key value hash of what to write out into the config file.
#   A key that can be specified multiple times should set an
#   array when they wish to set multiple values.
#
#   See the examples.
#
# @example
#   gssproxy::service { 'service/nfs-client':
#     settings          => {
#       'mechs'         => 'krb5',
#       'cred_store'    => [
#         'keytab:/etc/krb5.keytab',
#         'ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U',
#         'client_keytab:/var/lib/gssproxy/clients/%U.keytab' ],
#       'cred_usage'    => 'initiate',
#       'allow_any_uid' => 'yes',
#       'trusted'       => 'yes',
#       'euid'          => 0,
#   }
# 
#   gssproxy::service { 'service/nfs-server':
#     settings        => {
#       'mechs'       => 'krb5',
#       'socket'      => '/run/gssproxy.sock',
#       'cred_store'  => 'keytab:/etc/krb5.keytab',
#       'trusted'     => 'yes',
#       'kernel_nfsd' => 'yes',
#       'euid'        => 0,
#   }
define gssproxy::service (
  $settings,
  String $section = $title,
  Optional[Pattern[/^\d\d-/]] $filename = undef,
  Integer $order = 50,
  Stdlib::Absolutepath $gssproxy_conf_d = $gssproxy::gssproxy_conf_d,
) {
  if ! defined(Class['gssproxy']) {
    fail('You must include the gssproxy base class before using any defined resources')
  }

  if $filename == undef {
    $filename_escape = regsubst(downcase($section), '[/\.]', '_', 'G')
    $filename_real = "${order}-${filename_escape}.conf"
  } else {
    $filename_real = $filename
  }

  file { "${gssproxy_conf_d}/${filename_real}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => epp('gssproxy/etc/gssproxy_conf.epp', { 'gssproxy_sections' => { $section => $settings }}),
    notify  => Class['gssproxy::system_service']
  }

}
