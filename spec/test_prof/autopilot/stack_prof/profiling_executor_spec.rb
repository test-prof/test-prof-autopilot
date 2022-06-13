# frozen_string_literal: true

require "test_prof/autopilot/stack_prof/profiling_executor"

describe TestProf::Autopilot::StackProf::ProfilingExecutor do
  subject { described_class.new(options) }

  let(:options) { {} }
  let(:report) { double("report") }

  describe "#start" do
    let(:command_executor) { TestProf::Autopilot::CommandExecutor }
    let(:report_class) { TestProf::Autopilot::StackProf::Report }

    before do
      TestProf::Autopilot.config.command = "rspec"
      TestProf::Autopilot::Registry.register(:stack_prof_report, TestProf::Autopilot::StackProf::Report)
    end

    it "builds proper env and report" do
      expect(command_executor).to receive(:execute).with({"TEST_STACK_PROF" => "1"}, "rspec")
      expect(report_class).to receive(:build).and_return(report)

      subject.start

      expect(subject.report).to eq report
    end

    context "with sample option" do
      let(:options) { {sample: 100} }

      it "builds proper env and report" do
        expect(command_executor).to receive(:execute).with({"TEST_STACK_PROF" => "1", "SAMPLE" => "100"}, "rspec")
        expect(report_class).to receive(:build).and_return(report)

        subject.start

        expect(subject.report).to eq report
      end
    end
  end
end
