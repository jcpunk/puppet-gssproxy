# frozen_string_literal: true

require 'spec_helper'

describe 'gssproxy::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when using defaults' do
        it { is_expected.to compile }
        it { is_expected.to have_package_resource_count(1) }
        it { is_expected.to contain_package('gssproxy').with_ensure('present') }
      end

      context 'when managing package' do
        let(:params) do
          {
            'manage_packages' => true,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_package_resource_count(1) }
        it { is_expected.to contain_package('gssproxy').with_ensure('present') }
      end

      context 'when not managing package' do
        let(:params) do
          {
            'manage_packages' => false,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_package_resource_count(0) }
        it { is_expected.not_to contain_package('gssproxy') }
      end

      context 'when using multi params' do
        let(:params) do
          {
            'packages' => ['a', 'b'],
            'manage_packages' => true,
            'packages_ensure' => 'latest',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_package_resource_count(2) }
        it { is_expected.not_to contain_package('gssproxy') }
        it { is_expected.to contain_package('a').with_ensure('latest') }
        it { is_expected.to contain_package('b').with_ensure('latest') }
      end

      context 'when removing' do
        let(:params) do
          {
            'manage_packages' => true,
            'packages_ensure' => 'absent',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_package_resource_count(1) }
        it { is_expected.to contain_package('gssproxy').with_ensure('absent') }
      end
    end
  end
end
