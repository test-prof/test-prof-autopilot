# frozen_string_literal: true

require "spec_helper"

describe "merge reports" do
  specify "run and print" do
    reports_glob = "spec/fixtures/event_prof_report*.json"

    run_command("bin/auto-test-prof --merge=event_prof --reports=#{reports_glob}") do |output|
      expect(output).to include "Merging event_prof reports at spec/fixtures/event_prof_report.json, spec/fixtures/event_prof_report_2.json"

      expect(output).to include "EventProf results for factory.create"
      expect(output).to include "FirstController"
      expect(output).to include "FirstModel"
    end
  end

  specify "run and save to file" do
    reports_glob = "spec/fixtures/event_prof_report*.json"

    run_command("bin/auto-test-prof --merge=event_prof --reports=#{reports_glob} --merge-format=json --merge-file=./test_prof_autopilot/combined.json") do |output|
      expect(output).to include "Merging event_prof reports at spec/fixtures/event_prof_report.json, spec/fixtures/event_prof_report_2.json"

      expect(output).to match(%r{Report saved:.*test_prof_autopilot/combined.json})
    end
  end
end
