# frozen_string_literal: true

require 'spec_helper'

describe 'gssproxy::service' do
  let(:pre_condition) do
    [
      'include ::gssproxy',
    ]
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with minimal params' do
        let(:title) { 'name/.var' }
        let(:params) do
          {
            'settings' => { 'key' => 'value' },
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file('/etc/gssproxy/50-name__var.conf')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .without_content(%r{^\[gssproxy\]$})
            .with_content(%r{^\[name/.var\]$})
            .with_content(%r{^  key=value$})
            .with_notify('Class[Gssproxy::System_service]')
        }
      end

      context 'with bad filename param' do
        let(:title) { 'name/.var' }
        let(:params) do
          {
            'filename' => 'thing.conf',
            'settings' => { 'key' => 'value' },
          }
        end

        it { is_expected.not_to compile }
      end

      context 'with filename params' do
        let(:title) { 'name/.var' }
        let(:params) do
          {
            'filename' => '11-thing.conf',
            'settings' => { 'key' => 'value' },
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file('/etc/gssproxy/11-thing.conf')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .without_content(%r{^\[gssproxy\]$})
            .with_content(%r{^\[name/.var\]$})
            .with_content(%r{^  key=value$})
            .with_notify('Class[Gssproxy::System_service]')
        }
      end


      context 'with minimal interesting params' do
        let(:title) { 'namevar' }
        let(:params) do
          {
            'section' => 'service/nfs-client',
            'gssproxy_conf_d' => '/some/path',
            'settings' => {
              'mechs' => 'krb5',
              'cred_store' => [ 'keytab:/etc/krb5.keytab',
                                'ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U',
                                'client_keytab:/var/lib/gssproxy/clients/%U.keytab' ],
              'cred_usage' => 'initiate',
              'allow_any_uid' => 'yes',
              'trusted' => 'yes',
              'euid' => 0,
            }
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file('/some/path/50-service_nfs-client.conf')
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
            .with_content(%r{^  cred_usage=initiate$})
            .with_content(%r{^  allow_any_uid=yes$})
            .with_content(%r{^  trusted=yes$})
            .with_content(%r{^  euid=0$})
            .with_notify('Class[Gssproxy::System_service]')
        }
      end
    end
  end
end
