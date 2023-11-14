# frozen_string_literal: true

require "test_prof/autopilot/command_executor"

describe TestProf::Autopilot::CommandExecutor do
  subject { described_class }

  describe "#execute" do
    it "executes command in child process" do
      expect(Open3).to receive(:popen2e).with({"EVENT_PROF" => "factory.create", "TEST_PROF_AUTOPILOT_ENABLED" => "true"}, "rspec")

      subject.execute({"EVENT_PROF" => "factory.create"}, "rspec")
    end
  end
end
