# frozen_string_literal: true

require 'spec_helper'

describe 'gssproxy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when using defaults' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('gssproxy') }
        it { is_expected.to contain_class('gssproxy::config').that_requires('Class[gssproxy::install]') }
        it { is_expected.to contain_class('gssproxy::system_service').that_subscribes_to('Class[gssproxy::config]') }
        it { is_expected.to contain_class('gssproxy::system_service').that_subscribes_to('Class[gssproxy::install]') }
      end

      context 'with minimal interesting params' do
        let(:params) do
          {
            'gssproxy_services' => {
              'service/nfs-client' => {
                'settings' => {
                  'mechs' => 'krb5',
                  'cred_store' => [ 'keytab:/etc/krb5.keytab',
                                    'ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U',
                                    'client_keytab:/var/lib/gssproxy/clients/%U.keytab' ],
                }
              },
              'service/nfs-server' => {
                'settings' => {
                  'mechs' => 'krb5',
                  'cred_store' => 'keytab:/etc/krb5.keytab',
                }
              }
            }
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_file_resource_count(4) }
        it {
          is_expected.to contain_file('/etc/gssproxy/50-service_nfs-client.conf')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .without_content(%r{^\[gssproxy\]$})
            .with_content(%r{^\[service/nfs-client\]$})
            .with_content(%r{^  mechs=krb5$})
            .with_content(%r{^  cred_store=keytab:/etc/krb5.keytab$})
            .with_content(%r{^  cred_store=ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U$})
            .with_content(%r{^  cred_store=client_keytab:/var/lib/gssproxy/clients/%U.keytab$})
            .with_notify('Class[Gssproxy::System_service]')
        }
        it {
          is_expected.to contain_file('/etc/gssproxy/50-service_nfs-server.conf')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .without_content(%r{^\[gssproxy\]$})
            .with_content(%r{^\[service/nfs-server\]$})
            .with_content(%r{^  mechs=krb5$})
            .with_content(%r{^  cred_store=keytab:/etc/krb5.keytab$})
            .with_notify('Class[Gssproxy::System_service]')
        }
      end
    end
  end
end
