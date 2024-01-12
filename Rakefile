begin
  require 'puppetlabs_spec_helper/rake_tasks'
rescue LoadError
  # Allowed to fail, only needed in test
end

begin
  require 'beaker-rspec/rake_task'
rescue LoadError
  # Allowed to fail, only needed in acceptance
end

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
  # Allowed to fail, only needed in release
end

desc "Run main 'test' task and report merged results to coveralls"
task test_with_coveralls: [:test] do
  if Dir.exist?(File.expand_path('../lib', __FILE__))
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
    Rake::Task['coveralls:push'].invoke
  else
    puts 'Skipping reporting to coveralls.  Module has no lib dir'
  end
end

desc 'Generate REFERENCE.md'
task :reference, [:debug, :backtrace] do |t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
end

begin
  require 'github_changelog_generator/task'
  require 'puppet_blacksmith'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    metadata = Blacksmith::Modulefile.new
    config.future_release = "v#{metadata.version}" if metadata.version =~ /^\d+\.\d+.\d+$/
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file.\nEach new release typically also includes the latest modulesync defaults.\nThese should not affect the functionality of the module."
    config.exclude_labels = %w{duplicate question invalid wontfix wont-fix modulesync skip-changelog}
    config.user = 'Toutzn'
    config.project = 'puppet-motd'
  end

  # Workaround for https://github.com/github-changelog-generator/github-changelog-generator/issues/715
  require 'rbconfig'
  if RbConfig::CONFIG['host_os'] =~ /linux/
    task :changelog do
      puts 'Fixing line endings...'
      changelog_file = File.join(__dir__, 'CHANGELOG.md')
      changelog_txt = File.read(changelog_file)
      new_contents = changelog_txt.gsub(%r{\r\n}, "\n")
      File.open(changelog_file, "w") {|file| file.puts new_contents }
    end
  end

rescue LoadError
end