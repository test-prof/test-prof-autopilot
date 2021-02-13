# frozen_string_literal: true

describe TestProf::Autopilot::Configuration do
  subject { described_class.config }

  specify "defaults", :aggregate_failures do
    expect(subject.output).to eq $stdout
    expect(subject.artifacts_dir).to eq "tmp/test_prof_autopilot"
    expect(subject.plan_path).to be_nil
    expect(subject.command).to be_nil
  end
end
