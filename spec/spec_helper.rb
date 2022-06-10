# frozen_string_literal: true

begin
  require "pry-byebug"
rescue LoadError
end

require "test-prof-autopilot"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed

  config.before(:each) do
    # Clear configuration
    TestProf::Autopilot::Configuration.remove_instance_variable(:@config) if
      TestProf::Autopilot::Configuration.instance_variable_defined?(:@config)

    # Clear registry
    TestProf::Autopilot::Registry.instance_variable_set(:@items, {}) if
      TestProf::Autopilot::Registry.instance_variable_defined?(:@items)
  end
end
