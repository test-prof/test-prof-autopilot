# frozen_string_literal: true

require "test_prof/autopilot/runner"

describe TestProf::Autopilot::Runner do
  subject { described_class.new }

  let(:logging) { TestProf::Autopilot::Logging }

  describe "#run" do
    let(:executor_class) { TestProf::Autopilot::ProfilingExecutor }
    let(:executor) { double("executor") }
    let(:executor_result) { double("executor_result", report: report) }
    let(:report) { double("report") }

    it "executes profiling" do
      expect(executor_class).to receive(:new).with(:test_profiler, {}).and_return(executor)
      expect(executor).to receive(:start).and_return(executor_result)

      subject.run(:test_profiler, {})

      expect(subject.instance_variable_get("@report")).to eq report
    end
  end

  describe "#info" do
    context "when printable object is a report" do
      let(:printable_object) { double("report", printer: "event_prof") }

      it "prints info" do
        expect(TestProf::Autopilot::EventProf::Printer).to receive(:print_report)

        subject.info(printable_object)
      end
    end

    context "without printable object" do
      it "logs message" do
        expect(logging).to receive(:log).with("Specify data to print: 'report'")

        subject.info
      end
    end
  end

  describe "unknown_instruction" do
    it "logs message" do
      expect(logging).to receive(:log).with(
        <<~MSG
          'unknown_instruction' instruction is not supported.

          Look to supported instructions: 'run', 'info'.
        MSG
      )

      subject.unknown_instruction
    end
  end
end
