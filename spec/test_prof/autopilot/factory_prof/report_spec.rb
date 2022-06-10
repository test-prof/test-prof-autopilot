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
    TestProf::Autopilot::Configuration.config.artifacts_dir = "spec/fixtures"
  end

  describe ".build" do
    it "builds report" do
      report = subject.build

      expect(report.printer).to eq :factory_prof
      expect(report.raw_report).to eq raw_report
    end
  end
end
