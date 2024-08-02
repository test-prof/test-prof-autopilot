# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "simplecov-lcov"
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end

  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
  SimpleCov.start
end

require "debug" unless ENV["CI"]

require "active_support"
require "test-prof-autopilot"
# Load all the code
require "test_prof/autopilot/cli"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed

  config.before do
    # Clear configuration
    TestProf::Autopilot::Configuration.remove_instance_variable(:@config) if
      TestProf::Autopilot::Configuration.instance_variable_defined?(:@config)

    # Clear registry
    TestProf::Autopilot::Registry.instance_variable_set(:@items, {}) if
      TestProf::Autopilot::Registry.instance_variable_defined?(:@items)
  end

  config.after(:suite) do
    FileUtils.rm_rf("test_prof_autopilot")
    FileUtils.rm_rf("tmp/test_prof_autopilot")
  end
end
