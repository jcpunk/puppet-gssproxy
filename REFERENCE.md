# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`gssproxy`](#gssproxy): Manage and configure gssproxy

#### Private Classes

* `gssproxy::config`: load the vendor default gssproxy.conf
* `gssproxy::install`: Install the gssproxy package(s)
* `gssproxy::system_service`: manage the gssproxy service(s)

### Defined types

* [`gssproxy::service`](#gssproxyservice): Create gssproxy a service definition

## Classes

### <a name="gssproxy"></a>`gssproxy`

This class can install, configure, and manage the gssproxy service.
On most systems gssproxy ships with some services pre-defined.

To make it easier to integrate this module with the class that manages
those external services this class will provide zero gssproxy services.
By default any unmanaged services will be removed. You can disable this.

#### Examples

##### 

```puppet
include gssproxy

class { 'gssproxy':
  gssproxy_services => {
    'service/nfs-server' => {
       'settings' => {
         'mechs'       => 'krb5',
         'socket'      => '/run/gssproxy.sock',
         'cred_store'  => 'keytab:/etc/krb5.keytab',
         'trusted'     => 'yes',
         'kernel_nfsd' => 'yes',
         'euid'        => 0,
       }
    }
  }
}
```

#### Parameters

The following parameters are available in the `gssproxy` class:

* [`manage_packages`](#manage_packages)
* [`packages`](#packages)
* [`packages_ensure`](#packages_ensure)
* [`manage_conf`](#manage_conf)
* [`gssproxy_conf`](#gssproxy_conf)
* [`gssproxy_conf_d`](#gssproxy_conf_d)
* [`gssproxy_conf_d_purge_unmanaged`](#gssproxy_conf_d_purge_unmanaged)
* [`manage_system_services`](#manage_system_services)
* [`system_services`](#system_services)
* [`system_services_ensure`](#system_services_ensure)
* [`system_services_enable`](#system_services_enable)
* [`defaults`](#defaults)
* [`gssproxy_services`](#gssproxy_services)

##### <a name="manage_packages"></a>`manage_packages`

Data type: `Boolean`

Boolean to enable/disable the package managment of this module
Default is to manage packages

##### <a name="packages"></a>`packages`

Data type: `Array[String[1]]`

Array of packages for this program
Default: [ 'gssproxy' ]

##### <a name="packages_ensure"></a>`packages_ensure`

Data type: `String`

Passed directly to the ensure parameter of the listed packages
Default: 'present'

##### <a name="manage_conf"></a>`manage_conf`

Data type: `Boolean`

Boolean to enable/disable the config management of this module
Default is to manage the config

##### <a name="gssproxy_conf"></a>`gssproxy_conf`

Data type: `Stdlib::Absolutepath`

The absolute path to the gssproxy primary config.
Default is /etc/gssproxy/gssproxy.conf

##### <a name="gssproxy_conf_d"></a>`gssproxy_conf_d`

Data type: `Stdlib::Absolutepath`

The absolute path to the gssproxy include directory
Default is /etc/gssproxy

##### <a name="gssproxy_conf_d_purge_unmanaged"></a>`gssproxy_conf_d_purge_unmanaged`

Data type: `Boolean`

Boolean to remove any unmanaged files within $gssproxy_conf_d
Default is true

##### <a name="manage_system_services"></a>`manage_system_services`

Data type: `Boolean`

Boolean to manage the system service (systemd unit) state
Default is true

##### <a name="system_services"></a>`system_services`

Data type: `Array[String[1]]`

Array of system services for gssproxy
Default: [ 'gssproxy' ]

##### <a name="system_services_ensure"></a>`system_services_ensure`

Data type: `Stdlib::Ensure::Service`

The system service ensure state
Default: 'running'

##### <a name="system_services_enable"></a>`system_services_enable`

Data type: `Boolean`

The system service enable state
Default: true

##### <a name="defaults"></a>`defaults`

Data type: `Hash[String, Variant[Data, Array[String[1]], Undef]]`

The default settings for gssproxy.
Default: No settings

##### <a name="gssproxy_services"></a>`gssproxy_services`

Data type: `Optional[Hash[String, Variant[Data, Array[String[1]], Undef]]]`

A hash of gssproxy services to configure.
Running gssproxy without any configured services is weird.
But it probably makes more sense to configure them in the service
you are interfacing with rather than try to maintain them over here.
Default: No services

Default value: ``undef``

## Defined types

### <a name="gssproxyservice"></a>`gssproxy::service`

This resource creates gssproxy service definitions.
If you using your own management of the gssproxy system
service, you will need to setup your own notifications.
If you are using this module to manage the system service
notifications should happen automatically.

#### Examples

##### 

```puppet
gssproxy::service { 'service/nfs-client':
  settings          => {
    'mechs'         => 'krb5',
    'cred_store'    => [
      'keytab:/etc/krb5.keytab',
      'ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U',
      'client_keytab:/var/lib/gssproxy/clients/%U.keytab' ],
    'cred_usage'    => 'initiate',
    'allow_any_uid' => 'yes',
    'trusted'       => yes,
    'euid'          => 0,
}

gssproxy::service { 'service/nfs-server':
  settings        => {
    'mechs'       => 'krb5',
    'socket'      => '/run/gssproxy.sock',
    'cred_store'  => 'keytab:/etc/krb5.keytab',
    'trusted'     => 'yes',
    'kernel_nfsd' => 'yes',
    'euid'        => 0,
}
```

#### Parameters

The following parameters are available in the `gssproxy::service` defined type:

* [`section`](#section)
* [`force_this_filename`](#force_this_filename)
* [`filename`](#filename)
* [`order`](#order)
* [`gssproxy_conf_d`](#gssproxy_conf_d)
* [`settings`](#settings)

##### <a name="section"></a>`section`

Data type: `String`

Name of the section within the config file.
It defaults to the resource title.

Default value: `$title`

##### <a name="force_this_filename"></a>`force_this_filename`

Data type: `Optional[Stdlib::Absolutepath]`

Ignore any built in logic to try and simplify placement.
Just use this filename.
Default: unset

Default value: ``undef``

##### <a name="filename"></a>`filename`

Data type: `Optional[Pattern[/^\d\d-/]]`

Name of the config file to write out.
The filename must start with two digits and a - or gssproxy will not see it.
The filename must end in `.conf` or gssproxy will not see it.

Default value: ``undef``

##### <a name="order"></a>`order`

Data type: `Integer`

gssproxy requires config files to start with a 2 digit number
and then a `-`.  So we permit just setting the number prefix.
Default: 50

Default value: `50`

##### <a name="gssproxy_conf_d"></a>`gssproxy_conf_d`

Data type: `Stdlib::Absolutepath`

Directory where we will write the new service config file.
Default: from the gssproxy main class

Default value: `$gssproxy::gssproxy_conf_d`

##### <a name="settings"></a>`settings`

Data type: `Hash[String, Variant[Data, Array[String[1]], Undef]]`

A key value hash of what to write out into the config file.
A key that can be specified multiple times should set an
array when they wish to set multiple values.

See the examples.

