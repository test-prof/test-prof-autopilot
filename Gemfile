# frozen_string_literal: true

source "https://rubygems.org"

gem "debug", platform: :mri
gem "factory_bot"

gemspec

eval_gemfile "gemfiles/rubocop.gemfile"

local_gemfile = "#{File.dirname(__FILE__)}/Gemfile.local"

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Security/Eval
end

if ENV["COVERAGE"] == "true"
  gem "simplecov"
  gem "simplecov-lcov"
end
