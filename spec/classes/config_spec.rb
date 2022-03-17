# frozen_string_literal: true

require 'spec_helper'

describe 'gssproxy::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when using defaults' do
        it { is_expected.to compile }
        it { is_expected.to have_file_resource_count(2) }
        it {
          is_expected.to contain_file('/etc/gssproxy/gssproxy.conf')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .with_content(%r{^\[gssproxy\]$})
        }
        it {
          is_expected.to contain_file('/etc/gssproxy')
            .with_ensure('directory')
            .with_owner('root')
            .with_group('root')
            .with_mode('0750')
            .with_recurse(true)
            .with_purge(true)
        }
      end

      context 'manage_config == false' do
        let(:params) do
          {
            'manage_conf' => false,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_file_resource_count(0) }
      end

      context 'with params' do
        let(:params) do
          {
            'manage_conf' => true,
            'gssproxy_conf' => '/some/path',
            'gssproxy_conf_d' => '/some/path.d',
            'gssproxy_conf_d_purge_unmanaged' => false,
            'defaults' => { 'key' => 'value' },
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_file_resource_count(2) }
        it {
          is_expected.to contain_file('/some/path')
            .with_ensure('present')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .with_content(%r{^\[gssproxy\]$})
            .with_content(%r{^  key=value$})
        }
        it {
          is_expected.to contain_file('/some/path.d')
            .with_ensure('directory')
            .with_owner('root')
            .with_group('root')
            .with_mode('0750')
            .with_recurse(false)
            .with_purge(false)
        }
      end
    end
  end
end
