# frozen_string_literal: true

require "test_prof/autopilot/runner"

describe TestProf::Autopilot::Runner do
  subject { described_class }

  describe ".invoke" do
    let(:logging) { TestProf::Autopilot::Logging }

    before do
      allow(logging).to receive(:log)
    end

    it "sets up config" do
      subject.invoke("spec/fixtures/plans/blank_plan.rb", "rspec")

      expect(subject.instance_variable_get("@config")).to be_a TestProf::Autopilot::Runner::Configuration
      expect(subject.config.command).to eq "rspec"
      expect(subject.config.plan_path).to eq "spec/fixtures/plans/blank_plan.rb"
      expect(subject.config.output).to eq $stdout
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
