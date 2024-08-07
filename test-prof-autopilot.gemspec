# frozen_string_literal: true

require_relative "lib/test_prof/autopilot/version"

Gem::Specification.new do |s|
  s.name = "test-prof-autopilot"
  s.version = TestProf::Autopilot::VERSION
  s.authors = ["Ruslan Shakirov", "Vladimir Dementyev"]
  s.email = ["ruslan@shakirov.dev", "dementiev.vm@gmail.com"]
  s.homepage = "http://github.com/test-prof/test-prof-autopilot"
  s.summary = "Automatic TestProf runner"
  s.description = "Automatic TestProf runner"

  s.license = "MIT"

  s.files = Dir.glob("lib/**/*") + Dir.glob("bin/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  s.require_paths = ["lib"]
  s.required_ruby_version = ">= 2.7"
  s.executables = ["auto-test-prof"]

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/test-prof/test-prof-autopilot/issues",
    "changelog_uri" => "https://github.com/test-prof/test-prof-autopilot/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://test-prof.evilmartians.io/",
    "homepage_uri" => "https://test-prof.evilmartians.io/",
    "source_code_uri" => "https://github.com/test-prof/test-prof-autopilot",
    "funding_uri" => "https://github.com/sponsors/test-prof"
  }

  s.add_runtime_dependency "test-prof", "> 1.3.100", "< 1.5.0"

  s.add_development_dependency "bundler", ">= 1.15"
  s.add_development_dependency "rake", ">= 13.0"
  s.add_development_dependency "rspec", ">= 3.10"
  s.add_development_dependency "stackprof", ">= 0.2.9"
end
