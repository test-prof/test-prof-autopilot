# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor"

describe TestProf::Autopilot::ProfilingExecutor do
  subject { described_class.new(profiler, options) }

  let(:options) { {} }
  let(:report) { double("report") }
  let(:config) { double("config", command: "rspec") }

  describe "#start" do
    context "when unknown profiler" do
      let(:profiler) { :test_profiler }

      it "raises error" do
        expect { subject.start }.to raise_error(ArgumentError)
      end
    end

    context "when event_prof profiler" do
      let(:profiler) { :event_prof }
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

    context "when factory_prof profiler" do
      let(:profiler) { :factory_prof }

      it "builds proper env and report" do
        allow(TestProf::Autopilot::Runner).to receive(:config).and_return(config)

        expect(Open3).to receive(:popen2e).with({"FPROF" => "1"}, "rspec")
        expect(TestProf::Autopilot::FactoryProf::Report).to receive(:build).and_return(report)

        subject.start

        expect(subject.instance_variable_get("@report")).to eq report
      end

      context "with sample option" do
        let(:options) { {event: "factory.create", sample: 100} }

        it "builds proper env and report" do
          allow(TestProf::Autopilot::Runner).to receive(:config).and_return(config)

          expect(Open3).to receive(:popen2e).with({"FPROF" => "1", "SAMPLE" => "100"}, "rspec")
          expect(TestProf::Autopilot::FactoryProf::Report).to receive(:build).and_return(report)

          subject.start

          expect(subject.instance_variable_get("@report")).to eq report
        end
      end

      context "with paths option" do
        let(:options) { {paths: "./spec/controllers/first_controller_spec.rb ./spec/controllers/second_controller_spec.rb"} }

        it "builds proper env and report" do
          allow(TestProf::Autopilot::Runner).to receive(:config).and_return(config)

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
end
