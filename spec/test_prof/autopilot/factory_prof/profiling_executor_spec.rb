# frozen_string_literal: true

require "test_prof/autopilot/factory_prof/profiling_executor"

describe TestProf::Autopilot::FactoryProf::ProfilingExecutor do
  subject { described_class.new(options) }

  let(:options) { {} }
  let(:report) { double("report") }

  describe "#start" do
    let(:command_executor) { TestProf::Autopilot::CommandExecutor }
    let(:report_class) { TestProf::Autopilot::FactoryProf::Report }

    before do
      TestProf::Autopilot.config.command = "rspec"
      TestProf::Autopilot::Registry.register(:factory_prof_report, TestProf::Autopilot::FactoryProf::Report)
    end

    it "builds proper env and report" do
      expect(command_executor).to receive(:execute).with({"FPROF" => "1"}, "rspec")
      expect(report_class).to receive(:build).and_return(report)

      subject.start

      expect(subject.report).to eq report
    end

    context "with sample option" do
      let(:options) { {event: "factory.create", sample: 100} }

      it "builds proper env and report" do
        expect(command_executor).to receive(:execute).with({"FPROF" => "1", "SAMPLE" => "100"}, "rspec")
        expect(report_class).to receive(:build).and_return(report)

        subject.start

        expect(subject.report).to eq report
      end
    end

    context "with paths option" do
      let(:options) { {paths: "./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"} }

      it "builds proper env and report" do
        expect(command_executor).to receive(:execute).with(
          {"FPROF" => "1"},
          "rspec ./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"
        )
        expect(report_class).to receive(:build).and_return(report)

        subject.start

        expect(subject.report).to eq report
      end
    end
  end
end
