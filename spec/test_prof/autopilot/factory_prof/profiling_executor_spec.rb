# frozen_string_literal: true

require "test_prof/autopilot/factory_prof/profiling_executor"

describe TestProf::Autopilot::FactoryProf::ProfilingExecutor do
  subject { described_class.new(options) }

  let(:options) { {} }
  let(:report) { double("report") }

  describe "#start" do
    before do
      TestProf::Autopilot::Configuration.config.command = "rspec"
      TestProf::Autopilot::Registry.register(:factory_prof_report, TestProf::Autopilot::FactoryProf::Report)
    end

    it "builds proper env and report" do
      expect(Open3).to receive(:popen2e).with({"FPROF" => "1"}, "rspec")
      expect(TestProf::Autopilot::FactoryProf::Report).to receive(:build).and_return(report)

      subject.start

      expect(subject.instance_variable_get("@report")).to eq report
    end

    context "with sample option" do
      let(:options) { {event: "factory.create", sample: 100} }

      it "builds proper env and report" do
        expect(Open3).to receive(:popen2e).with({"FPROF" => "1", "SAMPLE" => "100"}, "rspec")
        expect(TestProf::Autopilot::FactoryProf::Report).to receive(:build).and_return(report)

        subject.start

        expect(subject.instance_variable_get("@report")).to eq report
      end
    end

    context "with paths option" do
      let(:options) { {paths: "./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"} }

      it "builds proper env and report" do
        expect(Open3).to receive(:popen2e).with(
          {"FPROF" => "1"},
          "rspec ./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"
        )
        expect(TestProf::Autopilot::FactoryProf::Report).to receive(:build).and_return(report)

        subject.start

        expect(subject.instance_variable_get("@report")).to eq report
      end
    end
  end
end
