# frozen_string_literal: true

require "test_prof/autopilot/runner"

class DummyExecutor < TestProf::Autopilot::ProfilingExecutor::Base
  def start
    @report = "report"
    self
  end
end

class DummyPrinter
  def print_report(_printable_object)
  end
end

describe TestProf::Autopilot::Runner do
  subject { described_class.new }

  describe "#run" do
    let(:logging) { TestProf::Autopilot::Logging }

    before do
      TestProf::Autopilot::Registry.register(:dummy_prof_executor, DummyExecutor)

      allow(logging).to receive(:log)
    end

    it "executes profiling" do
      expect(subject.report).to be_nil

      subject.run(:dummy_prof)

      expect(subject.report).to eq "report"
    end

    context "with unknown profiler" do
      it "raises error" do
        expect { subject.run(:unknown_prof) }.to raise_error(KeyError)
      end
    end
  end

  describe "#info" do
    let(:printable_object) { double("printable_object", type: :dummy_prof) }

    before { TestProf::Autopilot::Registry.register(:dummy_prof_printer, DummyPrinter) }

    it "calls printer" do
      expect(DummyPrinter).to receive(:print_report).with(printable_object)

      subject.info(printable_object)
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
