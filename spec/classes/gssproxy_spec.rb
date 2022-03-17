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
    end
  end
end
