# frozen_string_literal: true

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

# === Release-Tasks (nur für module:bump, release, etc.) ===
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
  require 'puppet_blacksmith'

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    metadata = Blacksmith::Modulefile.new

    # future_release nur setzen, wenn Version wie x.y.z aussieht
    if metadata.version =~ /^\d+\.\d+\.\d+$/
      config.future_release = "v#{metadata.version}"
    end

    # Hier dein tatsächliches GitHub-Repo
    config.user    = 'Toutzn'
    config.project = 'puppet-motd'

    config.header = <<~HEADER
      # Changelog

      All notable changes to this project will be documented in this file.
      Each new release typically also includes the latest modulesync defaults.
      These should not affect the functionality of the module.
    HEADER

    config.exclude_labels = %w[duplicate question invalid wontfix wont-fix modulesync skip-changelog]
  end

  # Workaround für CRLF unter Linux (optional, aber oft hilfreich)
  require 'rbconfig'
  if RbConfig::CONFIG['host_os'] =~ /linux/
    task :changelog do
      puts 'Fixing line endings...'
      changelog_file = File.join(__dir__, 'CHANGELOG.md')
      changelog_txt  = File.read(changelog_file)
      new_contents   = changelog_txt.gsub(%r{\r\n}, "\n")
      File.open(changelog_file, 'w') { |file| file.puts new_contents }
    end
  end
rescue LoadError
  # github_changelog_generator oder puppet_blacksmith nicht installiert
end