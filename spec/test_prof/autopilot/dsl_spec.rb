# frozen_string_literal: true

require "test_prof/autopilot/runner"

describe TestProf::Autopilot::Runner do
  subject { described_class.new }

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
      let(:printable_object) { double("report", printer: :event_prof) }

      it "prints info" do
        expect(TestProf::Autopilot::EventProf::Printer).to receive(:print_report)

        subject.info(printable_object)
      end
    end

    context "without printable object" do
      it "raises error" do
        expect { subject.info }.to raise_error(ArgumentError)
      end
    end
  end

  describe "unknown_instruction" do
    it "raises error" do
      expect { subject.unknown_instruction }.to raise_error(NoMethodError)
    end
  end
end
