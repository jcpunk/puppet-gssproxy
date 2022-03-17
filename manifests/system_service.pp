# @api private
#
# @summary manage the gssproxy service(s)
#
class gssproxy::system_service (
  $system_services = $gssproxy::system_services,
  $manage_system_services = $gssproxy::manage_system_services,
  $system_services_ensure = $gssproxy::system_services_ensure,
  $system_services_enable = $gssproxy::system_services_enable,
) inherits gssproxy {
  assert_private()

  if $manage_system_services {
    service { $system_services:
      ensure => $system_services_ensure,
      enable => $system_services_enable,
    }
  }

}
