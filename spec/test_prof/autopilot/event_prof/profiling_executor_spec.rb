# frozen_string_literal: true

require "test_prof/autopilot/event_prof/profiling_executor"

describe TestProf::Autopilot::EventProf::ProfilingExecutor do
  subject { described_class.new(options) }

  let(:options) { {} }
  let(:report) { double("report") }
  let(:config) { double("config", command: "rspec") }

  describe "#start" do
    let(:options) { {event: "factory.create"} }

    it "builds proper env and report" do
      allow(TestProf::Autopilot::Runner).to receive(:config).and_return(config)

      expect(Open3).to receive(:popen2e).with({"EVENT_PROF" => "factory.create"}, "rspec")
      expect(TestProf::Autopilot::EventProf::Report).to receive(:build).and_return(report)

      subject.start

      expect(subject.instance_variable_get("@report")).to eq report
    end

    context "without event option" do
      let(:options) { {} }

      it "raises error" do
        expect { subject.start }.to raise_error(ArgumentError)
      end
    end

    context "with sample option" do
      let(:options) { {event: "factory.create", sample: 100} }

      it "builds proper env and report" do
        allow(TestProf::Autopilot::Runner).to receive(:config).and_return(config)

        expect(Open3).to receive(:popen2e).with({"EVENT_PROF" => "factory.create", "SAMPLE" => "100"}, "rspec")
        expect(TestProf::Autopilot::EventProf::Report).to receive(:build).and_return(report)

        subject.start

        expect(subject.instance_variable_get("@report")).to eq report
      end
    end

    context "with paths option" do
      let(:options) { {event: "factory.create", paths: "./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"} }

      it "builds proper env and report" do
        allow(TestProf::Autopilot::Runner).to receive(:config).and_return(config)

        expect(Open3).to receive(:popen2e).with(
          {"EVENT_PROF" => "factory.create"},
          "rspec ./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"
        )
        expect(TestProf::Autopilot::EventProf::Report).to receive(:build).and_return(report)

        subject.start

        expect(subject.instance_variable_get("@report")).to eq report
      end
    end
  end
end
