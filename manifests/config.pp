# @api private
#
# @summary load the vendor default gssproxy.conf
#
class gssproxy::config (
  $manage_conf = $gssproxy::manage_conf,
  $gssproxy_conf = $gssproxy::gssproxy_conf,
  $gssproxy_conf_d = $gssproxy::gssproxy_conf_d,
  $gssproxy_conf_d_purge_unmanaged = $gssproxy::gssproxy_conf_d_purge_unmanaged,
  $defaults = $gssproxy::defaults,
) inherits gssproxy {
  assert_private()

  if $manage_conf {

    gssproxy::service { 'gssproxy':
      force_this_filename => $gssproxy_conf,
      settings            => $defaults,
    }

    file { $gssproxy_conf_d:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      recurse => $gssproxy_conf_d_purge_unmanaged,
      purge   => $gssproxy_conf_d_purge_unmanaged,
    }

  }
}
