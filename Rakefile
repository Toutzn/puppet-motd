# frozen_string_literal: true

require 'json'

# === Tests, Lint, Syntax etc. (voxpupuli-test) ===
begin
  require 'voxpupuli/test/rake'
rescue LoadError
  # nur in Test-Umgebung relevant
end

# === Acceptance / Beaker (voxpupuli-acceptance) ===
begin
  require 'voxpupuli/acceptance/rake'
rescue LoadError
  # nur relevant, wenn :system_tests installiert sind
end

# --- GitHub Repo für Changelog / Release fest verdrahten ---
ENV['CHANGELOG_GITHUB_USER']    ||= 'Toutzn'
ENV['CHANGELOG_GITHUB_PROJECT'] ||= 'puppet-motd'

# === Release-Tasks (voxpupuli-release) ===
begin
  require 'voxpupuli/release/rake_tasks'
rescue LoadError
  # nur relevant, wenn :release installiert ist
end

# === REFERENCE.md generieren ===
desc 'Generate REFERENCE.md'
task :reference, %i[debug backtrace] do |_t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
end

# === Eigener CHANGELOG-Task mit korrektem GitHub-Repo ===
begin
  require 'github_changelog_generator/task'

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    # Version aus metadata.json lesen
    metadata = JSON.parse(File.read('metadata.json'))
    version  = metadata['version']

    # future_release auf aktuelle Version setzen (ohne führendes "v")
    config.future_release = version

    # Dein tatsächliches GitHub-Repo
    config.user    = 'Toutzn'
    config.project = 'puppet-motd'

    # Token aus ENV (hast du schon exportiert)
    config.token = ENV['CHANGELOG_GITHUB_TOKEN']

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

  # Workaround für CRLF unter Linux: an bestehenden :changelog-Task anhängen
  require 'rbconfig'
  if RbConfig::CONFIG['host_os'] =~ /linux/
    Rake::Task['changelog'].enhance do
      puts 'Fixing line endings in CHANGELOG.md...'
      changelog_file = File.join(__dir__, 'CHANGELOG.md')
      next unless File.exist?(changelog_file)

      changelog_txt = File.read(changelog_file)
      new_contents  = changelog_txt.gsub(%r{\r\n}, "\n")
      File.open(changelog_file, 'w') { |file| file.puts new_contents }
    end
  end
rescue LoadError
  # github_changelog_generator nicht installiert
end

# === Override: release:porcelain:changelog soll unseren :changelog benutzen ===
begin
  # voxpupuli-release definiert den Task – wir leeren ihn und definieren neu
  Rake::Task['release:porcelain:changelog'].clear
rescue NameError
  # Task war noch nicht definiert – dann definieren wir ihn einfach
end

namespace :release do
  namespace :porcelain do
    desc 'Generate changelog for this module using github_changelog_generator'
    task :changelog do
      # sicherheitshalber Version aus metadata.json in FUTURE_RELEASE setzen
      metadata = JSON.parse(File.read('metadata.json'))
      ENV['FUTURE_RELEASE'] ||= metadata['version']

      # unseren eigenen :changelog-Task aufrufen
      Rake::Task['changelog'].invoke
    end
  end
end
