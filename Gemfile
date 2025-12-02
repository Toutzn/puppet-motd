source 'https://rubygems.org'

group :development do
end

group :test do
  gem 'puppet', ENV.fetch('PUPPET_GEM_VERSION', '>= 0'), require: false
  gem 'puppet_metadata', '~> 5.3',  require: false
  gem 'voxpupuli-test', '~> 13.2', require: false
end

group :system_tests do
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.2')
    # GitHub CI, Ruby >= 3.2 → moderne Version
    gem 'voxpupuli-acceptance', '~> 4.2', require: false
  else
    # act / Ruby 2.7 → letzte Version, die 2.7 unterstützt
    gem 'voxpupuli-acceptance', '~> 3.8', require: false
  end
end

group :release do
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.2')
    # Neue Release-Tools, nur Ruby >= 3.2
    gem 'voxpupuli-release', '~> 5.0', '>= 5.0', require: false
  else
    # Ältere Release-Tools, die noch Ruby 2.7 können
    gem 'voxpupuli-release', '~> 3.2', '>= 3.2.3', require: false
  end
end