# frozen_string_literal: true

require 'spec_helper'

describe 'twit_motd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('twit_motd::params') }
      it { is_expected.to contain_class('twit_motd::config') }
      it { is_expected.to contain_concat__fragment('motd_header') }
      it { is_expected.to contain_concat__fragment('motd_registered_modules') }
      it { is_expected.to contain_twit_motd__register('twit_motd') }

      case os_facts[:osfamily]
      when 'FreeBSD'
        case os_facts.dig(:os, 'release', 'major')
        when '12'
          it { is_expected.to contain_concat('/etc/motd').with_group('wheel').with_owner('root').with_mode('0644') }
          it do
            is_expected.to contain_concat__fragment('motd_registered_modules').with(
              'target'  => '/etc/motd',
              'content' => "    Registered puppet modules:\n",
              'order'   => '09',
            )
          end
          it do
            is_expected.to contain_concat__fragment('motd_footer').with(
              'target'  => '/etc/motd',
              'order'   => '15',
            )
          end
          it do
            is_expected.to contain_concat__fragment('motd_fragment_twit_motd').with(
              'target'  => '/etc/motd',
              'order'   => '10',
              'content' => "      -- twit_motd\n",
            )
          end
        when '13', '14'
          it { is_expected.to contain_concat('/etc/motd.template').with_group('wheel').with_owner('root').with_mode('0644') }
          it { is_expected.to contain_class('Twit_motd::Notify') }
          it do
            is_expected.to contain_exec('motd_reload').with(
              'refreshonly' => 'true',
              'path'        => ['/usr/bin','/usr/sbin','/bin','/sbin','/usr/local/bin','/usr/local/sbin'],
              'command'     => 'service motd onerestart',
            )
          end
          it do
            is_expected.to contain_concat__fragment('motd_registered_modules').with(
              'target'  => '/etc/motd.template',
              'content' => "    Registered puppet modules:\n",
              'order'   => '09',
            )
          end
          it do
            is_expected.to contain_concat__fragment('motd_footer').with(
              'target'  => '/etc/motd.template',
              'order'   => '15',
            )
          end
          it do
            is_expected.to contain_concat__fragment('motd_fragment_twit_motd').with(
              'target'  => '/etc/motd.template',
              'order'   => '10',
              'content' => "      -- twit_motd\n",
            )
          end
        end
      when 'Debian'
        it { is_expected.to contain_concat('/etc/motd').with_group('root').with_owner('root').with_mode('0644') }
        it do
          is_expected.to contain_concat__fragment('motd_registered_modules').with(
            'target'  => '/etc/motd',
            'content' => "    Registered puppet modules:\n",
            'order'   => '09',
          )
        end
        it do
          is_expected.to contain_concat__fragment('motd_footer').with(
            'target'  => '/etc/motd',
            'order'   => '15',
          )
        end
        it do
          is_expected.to contain_concat__fragment('motd_fragment_twit_motd').with(
            'target'  => '/etc/motd',
            'order'   => '10',
            'content' => "      -- twit_motd\n",
          )
        end
      end

      context 'when email is used' do
        let(:params) do
          {
            'motd_mailcontact' => 'fobar@mail.local',
          }
        end

        it { is_expected.to compile.with_all_deps }
      end

      context 'when motd is used' do
        let(:params) do
          {
            'motd_motd' => 'foobar'
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
