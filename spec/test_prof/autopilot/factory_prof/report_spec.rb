# frozen_string_literal: true

describe TestProf::Autopilot::FactoryProf::Report do
  subject { described_class }

  before do
    TestProf::Autopilot.config.tmp_dir = "spec/fixtures"
  end

  describe ".build" do
    it "builds report" do
      report = subject.build

      expect(report.type).to eq :factory_prof
      expect(report.result.total_count).to eq 9
      expect(report.result.stats.map { |st| st[:name] }).to eq(["user", "account"])
    end
  end

  describe "#merge" do
    it "merges two reports" do
      report_1 = described_class.new(JSON.parse(File.read("spec/fixtures/factory_prof_flamegraph_report.json")))
      report_2 = described_class.new(JSON.parse(File.read("spec/fixtures/factory_prof_flamegraph_report_2.json")))

      merged = report_1.merge(report_2)

      expect(merged.type).to eq :factory_prof
      expect(merged.result.stacks.size).to eq 13
      expect(merged.result.total_count).to eq 19
      expect(merged.result.stats.map { |st| st[:name] }).to eq(["user", "post", "account"])
    end
  end
end
