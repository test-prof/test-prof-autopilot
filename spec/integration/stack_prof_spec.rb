# frozen_string_literal: true

describe "stack prof scenario" do
  let(:command) { "'bundle exec rspec --require support/patches_load_helper.rb spec/fixtures/tests.rb'" }

  specify "run and print" do
    plan = "spec/fixtures/plans/stack_prof_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/stack_prof_plan.rb..."
      expect(output).to include("Executing 'run' with profiler:stack_prof and options:{:sample=>100}").once
      expect(output).to include("[TEST PROF INFO] StackProf (raw) enabled globally: mode – wall, target – suite").once

      expect(output).to include "=================================="
      expect(output).to include "Mode: wall(1000)"
      expect(output).to match(/Samples: \d+ \(\d{1,2}.\d{1,2}% miss rate\)/)
      expect(output).to match(/GC: \d+ \(\d{1,2}.\d{1,2}%\)/)
      expect(output).to include "=================================="

      expect(output).to include "TOTAL    (pct)     SAMPLES    (pct)     FRAME"
      expect(output).to match(/\d+\s+\(\d{1,2}.\d{1,2}%\)\s+\d+\s+\(\d{1,2}.\d{1,2}%\)\s+<top \(required\)>/)
    end
  end

  specify "aggregate and print" do
    plan = "spec/fixtures/plans/stack_prof_aggregate_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/stack_prof_aggregate_plan.rb..."
      expect(output).to include("Executing 'run' with profiler:stack_prof and options:{:sample=>100}").twice
      expect(output).to include("[TEST PROF INFO] StackProf (raw) enabled globally: mode – wall, target – suite").twice

      expect(output).to include "=================================="
      expect(output).to include "Mode: wall(1000)"
      expect(output).to match(/Samples: \d+ \(\d{1,2}.\d{1,2}% miss rate\)/)
      expect(output).to match(/GC: \d+ \(\d{1,2}.\d{1,2}%\)/)
      expect(output).to include "=================================="

      expect(output).to include "TOTAL    (pct)     SAMPLES    (pct)     FRAME"
      expect(output).to match(/\d+\s+\(\d{1,2}.\d{1,2}%\)\s+\d+\s+\(\d{1,2}.\d{1,2}%\)\s+<top \(required\)>/)
    end
  end
end
