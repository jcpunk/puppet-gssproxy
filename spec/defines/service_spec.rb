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
            .with_notify('Class[Gssproxy::System_service]')
            .with_content(/.*\[name\/.var\]\n  key=value\n.*/m)
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
        let(:title) { 'nAme/.var' }
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
            .with_notify('Class[Gssproxy::System_service]')
            .with_content(/.*\[nAme\/.var\]\n  key=value\n.*/m)
        }
      end

      context 'with force name params' do
        let(:title) { 'name/.var' }
        let(:params) do
          {
            'filename' => '11-thing.conf',
            'settings' => { 'key' => 'value' },
            'force_this_filename' => '/my/awesome/path.config',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file('/my/awesome/path.config')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .with_notify('Class[Gssproxy::System_service]')
            .with_content(/.*\[name\/.var\]\n  key=value\n.*/m)
        }
      end

      context 'with minimal interesting params' do
        let(:title) { 'namevar' }
        let(:params) do
          {
            'section' => 'service/NFS-client',
            'gssproxy_conf_d' => '/some/path',
            'order' => 22,
            'settings' => {
              'mechs' => 'krb5',
              'cred_store' => [ 'keytab:/etc/krb5.keytab',
                                'ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U',
                                'client_keytab:/var/lib/gssproxy/clients/%U.keytab' ],
              'cred_usage' => 'initiate',
              'allow_any_uid' => 'yes',
              'trusted' => true,
              'euid' => 0,
            }
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file('/some/path/22-service_nfs-client.conf')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .with_notify('Class[Gssproxy::System_service]')
            .with_content(/.*\[service\/NFS-client\]\n  allow_any_uid=yes\n  cred_store=keytab:\/etc\/krb5.keytab\n  cred_store=ccache:FILE:\/var\/lib\/gssproxy\/clients\/krb5cc_%U\n  cred_store=client_keytab:\/var\/lib\/gssproxy\/clients\/%U.keytab\n  cred_usage=initiate\n  euid=0\n  mechs=krb5\n  trusted=true\n.*/m)
        }
      end
    end
  end
end
