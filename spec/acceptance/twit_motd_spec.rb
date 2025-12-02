# frozen_string_literal: true

require 'spec_helper_acceptance'

# Hilfsfunktion, um den MOTD-Pfad je nach OS zu bestimmen
def motd_path
  case fact('osfamily')
  when 'FreeBSD'
    case fact('operatingsystemmajrelease')
    when '12'
      '/etc/motd'
    else
      # 13, 14, ...
      '/etc/motd.template'
    end
  when 'Debian'
    # gilt für Debian und Ubuntu
    '/etc/motd'
  else
    '/etc/motd'
  end
end

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

    it 'creates motd file with correct mode and content' do
      f = file(motd_path)

      expect(f).to be_file
      expect(f).to be_readable.by('others')
      expect(f).to be_owned_by 'root'

      # Modus 0644 – kann als "644" oder "0644" zurückkommen
      expect(f.mode).to match(%r{\A0?644\z})

      expect(f.content).to match(%r{Registered puppet modules})
      expect(f.content).to match(%r{-- twit_motd})
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

    it 'renders the custom motd in the motd file' do
      f = file(motd_path)
      expect(f.content).to match(%r{foobar})
    end
  end
end