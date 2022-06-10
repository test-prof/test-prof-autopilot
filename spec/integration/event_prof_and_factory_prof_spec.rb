# frozen_string_literal: true

describe "event prof + factory prof scenario" do
  let(:command) { "'bundle exec rspec --require support/patches_load_helper.rb spec/fixtures/tests.rb'" }

  specify "two run instructions and print" do
    plan = "spec/fixtures/plans/event_prof_and_factory_prof_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/event_prof_and_factory_prof_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:event_prof and options:{:event=>\"factory.create\"}"
      expect(output).to include "[TEST PROF INFO] EventProf enabled (factory.create)"

      expect(output).to include "Executing 'run' with profiler:factory_prof and options:{:paths=>\"./spec/fixtures/tests.rb:25 ./spec/fixtures/tests.rb:41\"}"
      expect(output).to include "[TEST PROF INFO] FactoryProf enabled (simple mode)"

      expect(output).to include "Factories usage"
      expect(output).to include "Total: 5"
      expect(output).to include "Total top-level: 5"
      expect(output).to match(/Total time: 0.\d{4}s/)
      expect(output).to include "Total uniq factories: 1"

      expect(output).to match(/total\s+top-level\s+total time\s+time per call\s+top-level time\s+name/)
      expect(output).to match(/\s+5\s+5\s+(\d+\.\d{4}s\s+){3}user/)
    end
  end

  specify "two run instructions without print" do
    plan = "spec/fixtures/plans/event_prof_and_factory_prof_wo_print_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/event_prof_and_factory_prof_wo_print_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:event_prof and options:{:event=>\"factory.create\"}"
      expect(output).to include "[TEST PROF INFO] EventProf enabled (factory.create)"

      expect(output).to include "Executing 'run' with profiler:factory_prof and options:{:paths=>\"./spec/fixtures/tests.rb:25 ./spec/fixtures/tests.rb:41\"}"
      expect(output).to include "[TEST PROF INFO] FactoryProf enabled (simple mode)"

      expect(output).not_to include "Factories usage"
      expect(output).not_to include "Total: 5"
      expect(output).not_to include "Total top-level: 5"
      expect(output).not_to match(/Total time: 0.\d{4}s/)
      expect(output).not_to include "Total uniq factories: 1"
      expect(output).not_to match(/total\s+top-level\s+total time\s+time per call\s+top-level time\s+name/)
      expect(output).not_to match(/\s+5\s+5\s+(\d+\.\d{4}s\s+){3}user/)
    end
  end
end
