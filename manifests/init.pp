# @summary Manage and configure gssproxy
#
# This class can install, configure, and manage the gssproxy service.
# On most systems gssproxy ships with some services pre-defined.
#
# To make it easier to integrate this module with the class that manages
# those external services this class will provide zero gssproxy services.
# By default any unmanaged services will be removed. You can disable this.
#
# @param manage_packages
#   Boolean to enable/disable the package managment of this module
#   Default is to manage packages
#
# @param packages
#   Array of packages for this program
#   Default: [ 'gssproxy' ]
#
# @param packages_ensure
#   Passed directly to the ensure parameter of the listed packages
#   Default: 'present'
#
# @param manage_conf
#   Boolean to enable/disable the config management of this module
#   Default is to manage the config
#
# @param gssproxy_conf
#   The absolute path to the gssproxy primary config.
#   Default is /etc/gssproxy/gssproxy.conf
#
# @param gssproxy_conf_d
#   The absolute path to the gssproxy include directory
#   Default is /etc/gssproxy
#
# @param gssproxy_conf_d_purge_unmanaged
#   Boolean to remove any unmanaged files within $gssproxy_conf_d
#   Default is true
#
# @param manage_system_services
#   Boolean to manage the system service (systemd unit) state
#   Default is true
#
# @param system_services
#   Array of system services for gssproxy
#   Default: [ 'gssproxy' ]
#
# @param system_services_ensure
#   The system service ensure state
#   Default: 'running'
#
# @param system_services_enable
#   The system service enable state
#   Default: true
#
# @param defaults
#   The default settings for gssproxy.
#   Default: No settings
#
# @param gssproxy_services
#   A hash of gssproxy services to configure.
#   Running gssproxy without any configured services is weird.
#   But it probably makes more sense to configure them in the service
#   you are interfacing with rather than try to maintain them over here.
#   Default: No services
#
# @example
#   include gssproxy
#
#   class { 'gssproxy':
#     gssproxy_services => {
#       'service/nfs-server' => {
#          'settings' => {
#            'mechs'       => 'krb5',
#            'socket'      => '/run/gssproxy.sock',
#            'cred_store'  => 'keytab:/etc/krb5.keytab',
#            'trusted'     => 'yes',
#            'kernel_nfsd' => 'yes',
#            'euid'        => 0,
#          }
#       }
#     }
#   }
class gssproxy (
  Boolean $manage_packages,
  Array[String[1]] $packages,
  String $packages_ensure,

  Boolean $manage_conf,
  Stdlib::Absolutepath $gssproxy_conf,
  Stdlib::Absolutepath $gssproxy_conf_d,
  Boolean $gssproxy_conf_d_purge_unmanaged,

  Boolean $manage_system_services,
  Array[String[1]] $system_services,
  Stdlib::Ensure::Service $system_services_ensure,
  Boolean $system_services_enable,

  Hash[String, Variant[Data, Array[String[1]], Undef]] $defaults,

  Optional[Hash[String, Variant[Data, Array[String[1]], Undef]]] $gssproxy_services = undef,
) {
  contain '::gssproxy::install'
  contain '::gssproxy::config'
  contain '::gssproxy::system_service'

  if $gssproxy_services {
    create_resources('gssproxy::service', $gssproxy_services)
  }

  # if you set ensure -> latest, the service should be kicked too
  Class['gssproxy::install'] -> Class['gssproxy::config'] ~> Class['gssproxy::system_service']
  Class['gssproxy::install'] ~> Class['gssproxy::system_service']
}
