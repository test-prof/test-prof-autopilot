# frozen_string_literal: true

require "spec_helper"

describe TestProf::Autopilot::TagProf::Report do
  subject { described_class }

  before do
    TestProf::Autopilot.config.tmp_dir = "spec/fixtures"
  end

  describe ".build" do
    it "builds report" do
      report = subject.build

      expect(report.type).to eq :tag_prof
      expect(report.result.tag).to eq "type"
      expect(report.result.events).to eq(["sql.active_record"])
      expect(report.result.data.keys).to match_array(["model", "controller"])
      expect(report.result.data["model"]).to match(a_hash_including(count: 4, time: 12.21))
    end
  end

  describe "#merge" do
    specify do
      report_1 = described_class.new(JSON.parse(File.read("spec/fixtures/tag_prof_report.json")))
      report_2 = described_class.new(JSON.parse(File.read("spec/fixtures/tag_prof_report_2.json")))

      merged = report_1.merge(report_2)

      expect(merged.type).to eq :tag_prof
      expect(merged.result.tag).to eq "type"
      expect(merged.result.events).to eq(["sql.active_record"])
      expect(merged.result.data.keys).to match_array(["model", "controller", "job"])
      expect(merged.result.data["model"]).to match(a_hash_including(count: 10, time: 42.22))
    end
  end
end
