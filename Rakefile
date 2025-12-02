# frozen_string_literal: true

require 'json'

# === Tests, Lint, Syntax etc. (voxpupuli-test) ==========================
begin
  require 'voxpupuli/test/rake'
rescue LoadError
  # nur in Test-Umgebung relevant
end

# === Acceptance / Beaker (voxpupuli-acceptance) =========================
begin
  require 'voxpupuli/acceptance/rake'
rescue LoadError
  # nur relevant, wenn :system_tests installiert sind
end

# === Release-Tasks (voxpupuli-release) ==================================
begin
  require 'voxpupuli/release/rake_tasks'
rescue LoadError
  # nur relevant, wenn :release installiert ist
end

# === REFERENCE.md generieren ============================================
desc 'Generate REFERENCE.md'
task :reference, %i[debug backtrace] do |_t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
end

# === Optional: Changelog-Task (manuell nutzbar) =========================
# Nutzt github_changelog_generator, aber wir fassen release:prepare NICHT an.
begin
  require 'github_changelog_generator/task'

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    # Repo explizit setzen
    config.user    = 'Toutzn'
    config.project = 'puppet-motd'

    # Token aus ENV, falls gesetzt
    config.token = ENV['CHANGELOG_GITHUB_TOKEN']

    # Version aus metadata.json lesen, z.B. 4.0.1
    metadata = JSON.parse(File.read('metadata.json'))
    version  = metadata['version']

    # Optional: future_release setzen (wenn du ihn doch nutzen willst)
    # Achtung: deine Tags heißen v4.0.0 usw.
    config.future_release = "v#{version}"

    config.header = <<~HEADER
      # Changelog

      All notable changes to this project will be documented in this file.
      Each new release typically also includes the latest modulesync defaults.
      These should not affect the functionality of the module.
    HEADER

    config.exclude_labels = %w[
      duplicate
      question
      invalid
      wontfix
      wont-fix
      modulesync
      skip-changelog
    ]
  end

rescue LoadError
  # github_changelog_generator nicht installiert → kein :changelog-Task
end
