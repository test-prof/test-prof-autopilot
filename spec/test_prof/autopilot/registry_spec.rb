# frozen_string_literal: true

require "test_prof/autopilot/registry"

class DummyClass; end

describe TestProf::Autopilot::Registry do
  subject { described_class }

  it "works" do
    subject.register(:dummy_class, DummyClass)

    expect(subject.fetch(:dummy_class)).to eq DummyClass
  end

  it "raises error when key is unknown" do
    expect { subject.fetch(:dummy_class) }.to raise_error(KeyError)
  end
end
