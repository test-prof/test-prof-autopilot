# frozen_string_literal: true

describe "tag prof scenario" do
  let(:command) { "'bundle exec rspec --require support/patches_load_helper.rb spec/fixtures/tests.rb'" }

  specify "run and print" do
    plan = "spec/fixtures/plans/tag_prof_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/tag_prof_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:tag_prof and options:{}"

      expect(output).to include "[TEST PROF INFO] TagProf enabled (type)"
      expect(output).to include "5 examples, 0 failures"
    end
  end

  specify "saving report" do
    plan = "spec/fixtures/plans/tag_prof_save_report_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/tag_prof_save_report_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:tag_prof and options:{:tag=>\"type\"}"
      expect(output).to include "[TEST PROF INFO] TagProf enabled (type)"

      expect(output).to include "5 examples, 0 failures"

      expect(output).to include "Report saved: test_prof_autopilot/tag_prof_report.json"
    end
  end

  specify "run with events" do
    plan = "spec/fixtures/plans/tag_prof_events_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/tag_prof_events_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:tag_prof and options:{:tag=>\"type\", :event=>\"factory.create\"}"

      expect(output).to include "[TEST PROF INFO] TagProf enabled (type)"
      expect(output).to include "5 examples, 0 failures"
    end
  end
end
