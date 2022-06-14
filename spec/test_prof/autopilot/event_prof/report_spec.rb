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
      "time_percentage" => 62.59,
      "groups" => [
        {
          "description" => "FirstController",
          "location" => "./spec/controllers/first_controller_spec.rb:1",
          "time" => 1.589380999514833,
          "count" => 123,
          "examples" => 14,
          "run_time" => 2.359970999951474,
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

  before do
    TestProf::Autopilot.config.tmp_dir = "spec/fixtures"
  end

  describe ".build" do
    it "builds report" do
      report = subject.build

      expect(report.type).to eq :event_prof
      expect(report.raw_report).to eq raw_report
    end
  end

  describe "#paths" do
    it "returns groups locations" do
      report = subject.build

      expect(report.paths).to eq "./spec/controllers/first_controller_spec.rb:1 ./spec/controllers/second_controller_spec.rb:1"
    end
  end

  describe "#merge" do
    let(:aggregated_report) do
      {
        "event" => "factory.create",
        "total_time" => 5.57876199903,
        "absolute_run_time" => 8.1199419999,
        "total_count" => 344,
        "top_count" => 10,
        "rank_by" => "time",
        "time_percentage" => 68.70445625225777,
        "groups" => [
          {
            "description" => "FirstModel",
            "location" => "./spec/models/first_model_spec.rb:1",
            "time" => 2.0,
            "count" => 120,
            "examples" => 10,
            "run_time" => 2.5,
            "time_percentage" => 90.0
          },
          {
            "description" => "FirstController",
            "location" => "./spec/controllers/first_controller_spec.rb:1",
            "time" => 1.589380999514833,
            "count" => 123,
            "examples" => 14,
            "run_time" => 2.359970999951474,
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
          },
          {
            "description" => "SecondModel",
            "location" => "./spec/models/second_model_spec.rb:1",
            "time" => 1.0,
            "count" => 80,
            "examples" => 9,
            "run_time" => 1.5,
            "time_percentage" => 66.59
          }
        ]
      }
    end

    specify do
      report_1 = described_class.new(JSON.parse(File.read("spec/fixtures/event_prof_report.json")))
      report_2 = described_class.new(JSON.parse(File.read("spec/fixtures/event_prof_report_2.json")))

      merged = report_1.merge(report_2)

      expect(merged.type).to eq :event_prof
      expect(merged.raw_report).to eq aggregated_report
    end
  end
end
