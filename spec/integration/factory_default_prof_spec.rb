# frozen_string_literal: true

require "spec_helper"

describe "factory default prof scenario" do
  let(:command) { "'bundle exec rspec --require support/patches_load_helper.rb spec/fixtures/tests.rb'" }

  specify "run and print" do
    plan = "spec/fixtures/plans/factory_default_prof_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/factory_default_prof_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:factory_default_prof and options:{}"

      expect(output).to include "Factory associations usage"
      expect(output).to match(/\s+user\s+2\s+\d{2}:\d{2}\.\d{3}/)

      # Custom output
      expect(output).to include "user - 2 times"
    end
  end
end
