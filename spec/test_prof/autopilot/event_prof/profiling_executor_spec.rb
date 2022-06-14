# frozen_string_literal: true

require "test_prof/autopilot/event_prof/profiling_executor"

describe TestProf::Autopilot::EventProf::ProfilingExecutor do
  subject { described_class.new(options) }

  let(:options) { {} }
  let(:report) { double("report") }

  describe "#start" do
    let(:command_executor) { TestProf::Autopilot::CommandExecutor }
    let(:report_class) { TestProf::Autopilot::EventProf::Report }

    let(:options) { {event: "factory.create"} }

    before do
      TestProf::Autopilot.config.command = "rspec"
      TestProf::Autopilot::Registry.register(:event_prof_report, TestProf::Autopilot::EventProf::Report)
    end

    it "builds proper env and report" do
      expect(command_executor).to receive(:execute).with({"EVENT_PROF" => "factory.create"}, "rspec")
      expect(report_class).to receive(:build).and_return(report)

      subject.start

      expect(subject.report).to eq report
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
        expect(command_executor).to receive(:execute).with({"EVENT_PROF" => "factory.create", "SAMPLE" => "100"}, "rspec")
        expect(report_class).to receive(:build).and_return(report)

        subject.start

        expect(subject.report).to eq report
      end
    end

    context "with paths option" do
      let(:options) { {event: "factory.create", paths: "./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"} }

      it "builds proper env and report" do
        expect(command_executor).to receive(:execute).with(
          {"EVENT_PROF" => "factory.create"},
          "rspec ./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"
        )
        expect(report_class).to receive(:build).and_return(report)

        subject.start

        expect(subject.report).to eq report
      end
    end
  end
end
