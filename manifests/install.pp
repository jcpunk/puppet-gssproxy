# @api private
#
# @summary Install the gssproxy package(s)
#
class gssproxy::install (
  $packages = $gssproxy::packages,
  $manage_packages = $gssproxy::manage_packages,
  $packages_ensure = $gssproxy::packages_ensure,
) inherits gssproxy {
  assert_private()

  if $manage_packages {
    package { $packages:
      ensure => $packages_ensure,
    }
  }

}
