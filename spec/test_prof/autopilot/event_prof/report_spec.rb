# frozen_string_literal: true

describe TestProf::Autopilot::EventProf::Report do
  subject { described_class }

  let(:raw_report) do
    {
      "event" => "factory.create",
      "total_time" => 2.57876199903,
      "absolute_run_time" => 4.1199419999,
      "total_count" => 144,
      "top_count" => 10,
      "rank_by" => "time",
      "groups" => [
        {
          "description" => "FirstController",
          "location" => "./spec/controllers/first_controller_spec.rb:1",
          "time" => 1.289380999514833,
          "run_time" => 2.059970999951474,
          "time_percentage" => 62.59
        },
        {
          "description" => "SecondController",
          "location" => "./spec/controllers/second_controller_spec.rb:1",
          "time" => 1.289380999514833,
          "run_time" => 2.059970999951474,
          "time_percentage" => 62.59
        }
      ]
    }
  end

  before do
    stub_const("#{described_class}::ARTIFACT_PATH", "spec/fixtures/event_prof_report.json")
  end

  describe ".build" do
    it "builds report" do
      report = subject.build

      expect(report.printer).to eq :event_prof
      expect(report.raw_report).to eq raw_report
    end
  end

  describe "#paths" do
    it "returns groups locations" do
      report = described_class.build

      expect(report.paths).to eq "./spec/controllers/first_controller_spec.rb:1 ./spec/controllers/second_controller_spec.rb:1"
    end
  end
end
