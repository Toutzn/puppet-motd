# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'twit_motd class' do
  context 'with default parameters' do
    let(:pp) do
      <<-MANIFEST
        class { 'twit_motd': }
      MANIFEST
    end

    it 'applies idempotently' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe 'motd file' do
      motd_path =
        case fact('osfamily')
        when 'FreeBSD'
          case fact('operatingsystemmajrelease')
          when '12'
            '/etc/motd'
          else
            '/etc/motd.template'
          end
        when 'Debian'
          '/etc/motd'
        else
          '/etc/motd'
        end

      describe file(motd_path) do
        it { is_expected.to be_file }
        it { is_expected.to be_readable.by('others') }
        it { is_expected.to be_owned_by 'root' }

        its(:mode) do
          is_expected.to match(%r{\A0?644\z})
        end

        its(:content) do
          is_expected.to match(%r{Registered puppet modules})
        end

        its(:content) do
          is_expected.to match(%r{-- twit_motd})
        end
      end
    end
  end

  context 'when motd_mailcontact is set' do
    let(:pp) do
      <<-MANIFEST
        class { 'twit_motd':
          motd_mailcontact => 'fobar@mail.local',
        }
      MANIFEST
    end

    it 'applies idempotently' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'when motd_motd is set' do
    let(:pp) do
      <<-MANIFEST
        class { 'twit_motd':
          motd_motd => 'foobar',
        }
      MANIFEST
    end

    it 'applies idempotently' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe 'motd content with custom motd' do
      motd_path =
        case fact('osfamily')
        when 'FreeBSD'
          case fact('operatingsystemmajrelease')
          when '12'
            '/etc/motd'
          else
            '/etc/motd.template'
          end
        when 'Debian'
          '/etc/motd'
        else
          '/etc/motd'
        end

      describe file(motd_path) do
        its(:content) do
          is_expected.to match(%r{foobar})
        end
      end
    end
  end
end