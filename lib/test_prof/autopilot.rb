# frozen_string_literal: true

require "test-prof"
require "test_prof/autopilot/configuration"

# We only load the patches when tests are executed by autopilot
# TODO: We should move the patches into TestProf itself as `--format=json`.
if ENV["TEST_PROF_AUTOPILOT_ENABLED"] == "true"
  require "test_prof/autopilot/patches/event_prof_patch"
  require "test_prof/autopilot/patches/tag_prof_patch"
  require "test_prof/autopilot/patches/factory_prof_patch"
  require "test_prof/autopilot/patches/stack_prof_patch"
end
