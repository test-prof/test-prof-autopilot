# frozen_string_literal: true

describe TestProf::Autopilot::Configuration do
  subject { described_class.new }

  specify "defaults", :aggregate_failures do
    expect(subject.output).to eq $stdout
    expect(subject.tmp_dir).to eq "tmp/test_prof_autopilot"
    expect(subject.artifacts_dir).to eq "test_prof_autopilot"
    expect(subject.plan_path).to be_nil
    expect(subject.command).to be_nil
  end
end
