# frozen_string_literal: true

# Coverage aktivieren, wenn es ein lib/-Verzeichnis gibt
ENV['COVERAGE'] ||= 'yes' if Dir.exist?(File.expand_path('../lib', __dir__))

require 'voxpupuli/test/spec_helper'
require 'rspec-puppet-facts'
require 'yaml'

# Optionales lokales Helper-File
require 'spec_helper_local' if File.file?(File.join(__dir__, 'spec_helper_local.rb'))

include RspecPuppetFacts

RSpec.configure do |c|
  c.mock_with :rspec

  # Moderne Einstellung für facterdb: keine String-Keys erzwingen
  c.facterdb_string_keys = false if c.respond_to?(:facterdb_string_keys=)

  c.before :each do
    # strengere Puppet-Einstellungen für Tests
    Puppet.settings[:strict] = :warning
    Puppet.settings[:strict_variables] = true
  end

  # Bolt-Tests nur, wenn explizit angefordert
  c.filter_run_excluding(bolt: true) unless ENV['GEM_BOLT']

  c.after(:suite) do
    # 100% Ressourcen-Coverage anstreben
    RSpec::Puppet::Coverage.report!(100)
  end

  # Backtrace etwas aufräumen
  backtrace_exclusion_patterns = [
    %r{spec_helper},
    %r{gems},
  ]

  if c.respond_to?(:backtrace_exclusion_patterns)
    c.backtrace_exclusion_patterns = backtrace_exclusion_patterns
  elsif c.respond_to?(:backtrace_clean_patterns)
    c.backtrace_clean_patterns = backtrace_exclusion_patterns
  end
end

# Basis-Facts aus facterdb hinzufügen (kommt aus voxpupuli-test / rspec-puppet-facts)
add_mocked_facts!

# Optional: zusätzliche Modul-Facts aus default_module_facts.yml
default_module_facts_file = File.expand_path(File.join(__dir__, 'default_module_facts.yml'))
if File.exist?(default_module_facts_file) && File.readable?(default_module_facts_file) && File.size?(default_module_facts_file)
  begin
    module_facts = YAML.safe_load(
      File.read(default_module_facts_file),
      permitted_classes: [],
      permitted_symbols: [],
      aliases: true,
    )

    module_facts&.each do |fact, value|
      add_custom_fact fact.to_sym, value, merge_facts: true
    end
  rescue StandardError => e
    RSpec.configuration.reporter.message "WARNING: Unable to load #{default_module_facts_file}: #{e}"
  end
end

# Ensures that a module is defined
# @param module_name Name of the module
def ensure_module_defined(module_name)
  module_name.split('::').reduce(Object) do |last_module, next_module|
    last_module.const_set(next_module, Module.new) unless last_module.const_defined?(next_module, false)
    last_module.const_get(next_module, false)
  end
end

# 'spec_overrides' from sync.yml will appear below this line