# frozen_string_literal: true

describe "event prof scenario" do
  let(:command) { "'bundle exec rspec --require support/patches_load_helper.rb spec/fixtures/tests.rb'" }

  specify "run and print" do
    plan = "spec/fixtures/plans/event_prof_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/event_prof_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:event_prof and options:{:event=>\"factory.create\"}"
      expect(output).to include "[TEST PROF INFO] EventProf enabled (factory.create)"

      expect(output).to include "EventProf results for factory.create"

      expect(output).to match(/Total time: 00:0\d\.\d{3} of 00:0\d\.\d{3} \(\d{1,2}\.\d+%\)/)
      expect(output).to include "Total events: 5"

      expect(output).to include "Top 5 slowest suites (by time):"
      expect(output).to match(/Something \(\.\/spec\/fixtures\/tests\.rb:27\) – 00:00\.\d{3} \(3 \/ 3\) of 00:0\d\.\d{3} \(\d{1,2}\.\d+%\)/)
      expect(output).to match(/Another something \(\.\/spec\/fixtures\/tests\.rb:43\) – 00:00\.\d{3} \(2 \/ 2\) of 00:0\d\.\d{3} \(\d{1,2}\.\d+%\)/)
    end
  end

  specify "run without print" do
    plan = "spec/fixtures/plans/event_prof_wo_print_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/event_prof_wo_print_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:event_prof and options:{:event=>\"factory.create\"}"
      expect(output).to include "[TEST PROF INFO] EventProf enabled (factory.create)"

      expect(output).not_to include "EventProf results for factory.create"
      expect(output).not_to match(/Total time: 00:0\d\.\d{3} of 00:0\d\.\d{3} \(\d{1,2}\.\d+%\)/)
      expect(output).not_to include "Total events: 5"
      expect(output).not_to include "Top 5 slowest suites (by time):"
      expect(output).not_to match(/Something \(\.\/spec\/fixtures\/tests\.rb:25\) – 00:00\.\d{3} \(3 \/ 3\) of 00:0\d\.\d{3} \(\d{1,2}\.\d+%\)/)
      expect(output).not_to match(/Another something \(\.\/spec\/fixtures\/tests\.rb:41\) – 00:00\.\d{3} \(2 \/ 2\) of 00:0\d\.\d{3} \(\d{1,2}\.\d+%\)/)
    end
  end

  specify "run with sample option and print" do
    plan = "spec/fixtures/plans/event_prof_with_sample_plan.rb"

    run_command("bin/auto-test-prof --plan #{plan} --command #{command}") do |output|
      expect(output).to include "Reading spec/fixtures/plans/event_prof_with_sample_plan.rb..."
      expect(output).to include "Executing 'run' with profiler:event_prof and options:{:event=>\"factory.create\", :sample=>1}"
      expect(output).to include "[TEST PROF INFO] EventProf enabled (factory.create)"

      expect(output).to include "1 example, 0 failures"

      expect(output).to include "EventProf results for factory.create"
      expect(output).to match(/Total time: 00:0\d\.\d{3} of 00:0\d\.\d{3} \(\d{1,2}\.\d+%\)/)
      expect(output).to include "Total events: 1"
    end
  end
end
