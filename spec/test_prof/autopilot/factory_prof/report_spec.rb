# frozen_string_literal: true

describe TestProf::Autopilot::FactoryProf::Report do
  subject { described_class }

  let(:raw_report) do
    {
      "total_count" => 40,
      "total_top_level_count" => 28,
      "total_time" => 2,
      "total_uniq_factories" => 2,
      "stats" => [
        {
          "name" => "user",
          "total_count" => 30,
          "top_level_count" => 18,
          "total_time" => 1,
          "top_level_time" => 1
        },
        {
          "name" => "application",
          "total_count" => 10,
          "top_level_count" => 10,
          "total_time" => 1,
          "top_level_time" => 1
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

      expect(report.type).to eq :factory_prof
      expect(report.raw_report).to eq raw_report
    end
  end

  describe "#merge" do
    let(:stacks) do
      [
        ["user"],
        ["user"],
        ["job", "user"],
        ["friend", "job", "user"],
        ["friend", "job", "user"],
        ["job", "user"]
      ]
    end

    it "merges two reports" do
      report_1 = described_class.new(JSON.parse(File.read("spec/fixtures/factory_prof_flamegraph_report.json")))
      report_2 = described_class.new(JSON.parse(File.read("spec/fixtures/factory_prof_flamegraph_report_2.json")))

      merged = report_1.merge(report_2)

      expect(merged.type).to eq :factory_prof
      expect(merged.raw_report["total"]).to eq 12
      expect(merged.raw_report["stacks"]).to eq stacks
    end
  end
end
