# Rakefile

# === Basis-Tasks: Lint, Spec, Test, strings:generate:reference, usw. ===
begin
  require 'voxpupuli/test/rake'
rescue LoadError
  # nur in der Test-Umgebung relevant
end

# === Acceptance / Beaker-Tasks (bundle exec rake beaker) ===
begin
  require 'voxpupuli/acceptance/rake'
rescue LoadError
  # nur relevant, wenn :system_tests installiert sind
end

# === Release-/Changelog-/Reference-Tasks ===
begin
  require 'voxpupuli/release/rake_tasks'
rescue LoadError
  # nur relevant, wenn :release installiert ist
end

# Optional: Alias, wenn du weiterhin `rake reference` tippen möchtest
desc 'Generate REFERENCE.md'
task :reference, %i[debug backtrace] do |_t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
end

# Optional: Coveralls – NUR wenn du es wirklich nutzt
# (Dann brauchst du zusätzlich `gem 'coveralls', require: false` im Gemfile)
desc "Run main 'test' task and report merged results to coveralls"
task test_with_coveralls: [:test] do
  if Dir.exist?(File.expand_path('../lib', __FILE__))
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
    Rake::Task['coveralls:push'].invoke
  else
    puts 'Skipping reporting to coveralls. Module has no lib dir'
  end
end