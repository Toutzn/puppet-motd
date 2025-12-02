# frozen_string_literal: true

require 'spec_helper'

describe 'twit_motd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Pfad zur MOTD-Datei nur vom OS-Namen abhängig
      let(:motd_path) do
        case os
        when %r{\Afreebsd-(13|14)}
          '/etc/motd.template'
        else
          '/etc/motd'
        end
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('twit_motd::params') }
      it { is_expected.to contain_class('twit_motd::config') }
      it { is_expected.to contain_concat__fragment('motd_header') }
      it { is_expected.to contain_concat__fragment('motd_registered_modules') }
      it { is_expected.to contain_twit_motd__register('twit_motd') }

      # Concat-Ressource selbst soll existieren
      it { is_expected.to contain_concat(motd_path) }

      # OS-spezifische Checks
      case os
      when %r{\Afreebsd-12}
        it do
          is_expected.to contain_concat('/etc/motd')
            .with_group('wheel')
            .with_owner('root')
            .with_mode('0644')
        end
      when %r{\Afreebsd-(13|14)}
        it do
          is_expected.to contain_concat('/etc/motd.template')
            .with_group('wheel')
            .with_owner('root')
            .with_mode('0644')
        end

        it { is_expected.to contain_class('Twit_motd::Notify') }

        it do
          is_expected.to contain_exec('motd_reload').with(
            'refreshonly' => 'true',
            'path'        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',
                              '/usr/local/bin', '/usr/local/sbin'],
            'command'     => 'service motd onerestart',
          )
        end
      when %r{\Adebian-}
        it do
          is_expected.to contain_concat('/etc/motd')
            .with_group('root')
            .with_owner('root')
            .with_mode('0644')
        end
      when %r{\Aubuntu-}
        # Ubuntu hängt am Debian-OS-Familie; Pfad und Rechte wie Debian
        it do
          is_expected.to contain_concat('/etc/motd')
            .with_group('root')
            .with_owner('root')
            .with_mode('0644')
        end
      end

      # Fragmente mit OS-abhängigem target
      it do
        is_expected.to contain_concat__fragment('motd_registered_modules').with(
          'target'  => motd_path,
          'content' => "    Registered puppet modules:\n",
          'order'   => '09',
        )
      end

      it do
        is_expected.to contain_concat__fragment('motd_footer').with(
          'target' => motd_path,
          'order'  => '15',
        )
      end

      it do
        is_expected.to contain_concat__fragment('motd_fragment_twit_motd').with(
          'target'  => motd_path,
          'order'   => '10',
          'content' => "      -- twit_motd\n",
        )
      end

      context 'when email is used' do
        let(:params) { { 'motd_mailcontact' => 'fobar@mail.local' } }

        it { is_expected.to compile.with_all_deps }
      end

      context 'when motd is used' do
        let(:params) { { 'motd_motd' => 'foobar' } }

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
