# frozen_string_literal: true

require 'spec_helper'

describe 'gssproxy::system_service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when using defaults' do
        it { is_expected.to compile }
        it { is_expected.to have_service_resource_count(1) }
        it { is_expected.to contain_service('gssproxy').with_ensure('running').with_enable(true) }
      end

      context 'when managing service' do
        let(:params) do
          {
            'manage_system_services' => true,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_service_resource_count(1) }
        it { is_expected.to contain_service('gssproxy').with_ensure('running').with_enable(true) }
      end

      context 'when not managing service' do
        let(:params) do
          {
            'manage_system_services' => false,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_service_resource_count(0) }
        it { is_expected.not_to contain_service('gssproxy') }
      end

      context 'when using multi params' do
        let(:params) do
          {
            'system_services' => ['a', 'b'],
            'manage_system_services' => true,
            'system_services_ensure' => 'stopped',
            'system_services_enable' => false,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_service_resource_count(2) }
        it { is_expected.not_to contain_service('gssproxy') }
        it { is_expected.to contain_service('a').with_ensure('stopped').with_enable(false) }
        it { is_expected.to contain_service('b').with_ensure('stopped').with_enable(false) }
      end

      context 'when stopping service, but staying enabled' do
        let(:params) do
          {
            'manage_system_services' => true,
            'system_services_ensure' => 'stopped',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_service_resource_count(1) }
        it { is_expected.to contain_service('gssproxy').with_ensure('stopped').with_enable(true) }
      end
    end
  end
end
