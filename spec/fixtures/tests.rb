# frozen_string_literal: true

begin; require "active_support/isolated_execution_state"; rescue LoadError; end

class User
  attr_accessor :name
end

class Job
  attr_accessor :title
end

FactoryBot.define do
  factory :user do
    skip_create
    sequence(:name) { |n| "Naruto #{n}" }
  end

  factory :job do
    skip_create
    sequence(:title) { |n| "Job ##{n}" }

    user
  end
end

describe "Something" do
  before { FactoryBot.create(:user) }

  it "invokes once" do
    expect(true).to eq true
  end

  it "invokes twice" do
    expect(true).to eq true
  end

  it "invokes again" do
    expect(true).to eq true
  end
end

describe "Another something" do
  before { FactoryBot.create(:user) }

  it "do something" do
    expect(true).to eq true
  end

  it "and again" do
    expect(true).to eq true
  end
end
