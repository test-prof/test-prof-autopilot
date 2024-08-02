# frozen_string_literal: true

require "spec_helper"

describe TestProf::Autopilot::EventProf::Printer do
  subject { described_class }

  let(:logging) { TestProf::Autopilot::Logging }
  let(:report) { double("report", raw_report: raw_report) }
  let(:raw_report) do
    {
      "event" => "factory.create",
      "total_time" => 2.57876199903,
      "absolute_run_time" => 4.1199419999,
      "total_count" => 144,
      "top_count" => 10,
      "rank_by" => "time",
      "time_percentage" => 62.59,
      "groups" => [
        {
          "description" => "FirstController",
          "location" => "./spec/controllers/first_controller_spec.rb:1",
          "time" => 1.289380999514833,
          "count" => 72,
          "examples" => 9,
          "run_time" => 2.059970999951474,
          "time_percentage" => 62.59
        },
        {
          "description" => "SecondController",
          "location" => "./spec/controllers/second_controller_spec.rb:1",
          "time" => 1.289380999514833,
          "count" => 72,
          "examples" => 9,
          "run_time" => 2.059970999951474,
          "time_percentage" => 62.59
        }
      ]
    }
  end

  let(:msgs) do
    <<~MSG
      EventProf results for factory.create

      Total time: 00:02.578 of 00:04.119 (62.59%)
      Total events: 144

      Top 10 slowest suites (by time):
      FirstController (./spec/controllers/first_controller_spec.rb:1) – 00:01.289 (72 / 9) of 00:02.059 (62.59%)
      SecondController (./spec/controllers/second_controller_spec.rb:1) – 00:01.289 (72 / 9) of 00:02.059 (62.59%)
    MSG
  end

  describe "print_report" do
    it "logs report" do
      expect(logging).to receive(:log).with(msgs)

      subject.print_report(report)
    end
  end
end
