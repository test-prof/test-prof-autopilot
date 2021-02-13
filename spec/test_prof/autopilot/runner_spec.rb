# frozen_string_literal: true

require "test_prof/autopilot/runner"

describe TestProf::Autopilot::Runner do
  subject { described_class }

  describe ".invoke" do
    let(:logging) { TestProf::Autopilot::Logging }
    let(:configuration) { TestProf::Autopilot::Configuration }

    before do
      allow(logging).to receive(:log)
    end

    it "sets up config" do
      subject.invoke("spec/fixtures/plans/blank_plan.rb", "rspec")

      expect(configuration.config.command).to eq "rspec"
      expect(configuration.config.plan_path).to eq "spec/fixtures/plans/blank_plan.rb"
    end

    it "creates runner instance" do
      expect(subject).to receive(:new)

      subject.invoke("spec/fixtures/plans/blank_plan.rb", "rspec")
    end

    it "raises error when without options" do
      expect { subject.invoke }.to raise_error(ArgumentError)
    end
  end
end
