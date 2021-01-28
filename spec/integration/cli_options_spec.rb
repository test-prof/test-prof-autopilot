# frozen_string_literal: true

require "spec_helper"

describe "auto-test-prof [options]" do
  specify "-v" do
    run_command("bin/auto-test-prof -v") do |output|
      expect(output).to include TestProf::Autopilot::VERSION
    end
  end

  specify "-h" do
    run_command("bin/auto-test-prof -h") do |output|
      expect(output).to include "Command to run tests"
      expect(output).to include "Path to test plan"
    end
  end

  context "missing options" do
    specify do
      run_command("bin/auto-test-prof", should_fail: true) do |_output, err|
        expect(err).to include "Test command must be specified"
      end
    end

    specify "no plan path" do
      run_command("bin/auto-test-prof --command 'rspec'", should_fail: true) do |_output, err|
        expect(err).to include "Plan path must be specified"
      end
    end

    specify "plan path is invalid" do
      run_command("bin/auto-test-prof --command 'rspec' --plan './does_not_exist.rb'", should_fail: true) do |_output, err|
        expect(err).to include "Plan ./does_not_exist.rb doesn't exist"
      end
    end
  end
end
