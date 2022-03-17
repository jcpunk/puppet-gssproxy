# gssproxy

Manage and configure the gssproxy service

## Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

The gssproxy service is used in a number of contexts to proxy kerberos
authentication for various applications.  The most common use is with
Kerberized NFS.

This module will setup the gssproxy service, but leave defining them to you.
See [Usage - Configuration options and additional functionality](#usage) for
more information.

## Usage

By default this class will define zero services for gssproxy to work with.
The idea here is that the service using gssproxy probably requires its own
configuration settings there, and it makes more sense to export an interface
for other services (such as nfs) to define their settings along side the
service itself.

But if you want to instead manage the gssproxy interface here you can do so
with something like:

```puppet
class { 'gssproxy':
  services => {
    'service/nfs-client' => {
      'settings' => {
         'mechs' => 'krb5',
         'cred_store' => [
            'keytab:/etc/krb5.keytab',
            'ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U',
            'client_keytab:/var/lib/gssproxy/clients/%U.keytab' ],
         'cred_usage' =>  'initiate',
         'allow_any_uid' => 'yes',
         'trusted' => 'yes',
         'euid' => 0,
    } },

    'service/nfs-server' => {
      'settings' =>
        'mechs' => 'krb5',
        'socket' => '/run/gssproxy.sock',
        'cred_store' => 'keytab:/etc/krb5.keytab',
        'trusted' => 'yes',
        'kernel_nfsd' => 'yes',
        'euid' => 0,
    }
  }
}
```

or in hiera

```yaml
gssproxy::services:
  'service/nfs-client':
    settings:
       mechs: krb5
       cred_store:
         - keytab:/etc/krb5.keytab
         - ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U
         - client_keytab:/var/lib/gssproxy/clients/%U.keytab
       cred_usage:  initiate
       allow_any_uid: 'yes'
       trusted: 'yes'
       euid: 0

  'service/nfs-server':
    settings:
      mechs: krb5
      socket: /run/gssproxy.sock
      cred_store: keytab:/etc/krb5.keytab
      trusted: 'yes'
      kernel_nfsd: 'yes'
      euid: 0
```

Include usage examples for common use cases in the **Usage** section. Show your
users how to use your module to solve problems, and be sure to include code
examples. Include three to five examples of the most important or common tasks a
user can accomplish with your module. Show users how to accomplish more complex
tasks that involve different types, classes, and functions working in tandem.

## Limitations

If you disable the management of the system service, the service defined type
will not automatically notify the system service of the change as it may be
undefined or have an unknown name.

## Development

Development takes place within the github repo.
