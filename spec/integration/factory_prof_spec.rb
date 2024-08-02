# frozen_string_literal: true

require "spec_helper"

describe "factory prof scenario" do
  let(:command) { "'bundle exec rspec --require support/patches_load_helper.rb spec/fixtures/tests.rb'" }

  specify "run and print" do
    plan = "spec/fixtures/plans/factory_prof_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/factory_prof_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:factory_prof and options:{}"
      expect(output).to include "[TEST PROF INFO] FactoryProf enabled (simple mode)"

      expect(output).to include "Factories usage"
      expect(output).to include "Total: 7"
      expect(output).to include "Total top-level: 5"
      expect(output).to include("Total time: ")
      expect(output).to include "Total uniq factories: 2"

      expect(output).to match(/name\s+total\s+top-level\s+total time\s+time per call\s+top-level time/)
      expect(output).to match(/user\s+5\s+3\s+(\d+\.\d{4}s\s+){3}/)
      expect(output).to match(/job\s+2\s+2\s+(\d+\.\d{4}s\s+){3}/)
    end
  end

  specify "run without print" do
    plan = "spec/fixtures/plans/factory_prof_wo_print_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/factory_prof_wo_print_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:factory_prof and options:{}"
      expect(output).to include "[TEST PROF INFO] FactoryProf enabled (simple mode)"

      expect(output).not_to include "Factories usage"
      expect(output).not_to include "Total: 5"
      expect(output).not_to include "Total top-level: 5"
      expect(output).not_to include "Total time: "
      expect(output).not_to include "Total uniq factories: 1"
      expect(output).not_to match(/total\s+top-level\s+total time\s+time per call\s+top-level time\s+name/)
      expect(output).not_to match(/\s+5\s+5\s+(\d+\.\d{4}s\s+){3}user/)
    end
  end

  specify "run with sample option and print" do
    plan = "spec/fixtures/plans/factory_prof_with_sample_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/factory_prof_with_sample_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:factory_prof and options:{:sample=>1}"
      expect(output).to include "[TEST PROF INFO] FactoryProf enabled (simple mode)"

      expect(output).to include "1 example, 0 failures"

      expect(output).to include "Factories usage"
      expect(output).to include "Total: "
      expect(output).to include "Total top-level: 1"
      expect(output).to include "Total time: "
      expect(output).to include "Total uniq factories: "

      expect(output).to match(/name\s+total\s+top-level\s+total time\s+time per call\s+top-level time/)
      expect(output).to match(/user\s+1\s+1\s+(\d+\.\d{4}s\s+){3}/)
    end
  end

  specify "run in flamegraph mode and write" do
    plan = "spec/fixtures/plans/factory_prof_flamegraph_save_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/factory_prof_flamegraph_save_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:factory_prof and options:{:flamegraph=>true}"
      expect(output).to include "[TEST PROF INFO] FactoryProf enabled (flamegraph mode)"

      expect(output).to include "5 examples, 0 failures"
    end

    expect(File).to exist("test_prof_autopilot/factory_prof_report.html")
  end
end
