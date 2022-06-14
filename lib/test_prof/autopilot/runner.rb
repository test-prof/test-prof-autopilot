# frozen_string_literal: true

require "test_prof/autopilot/configuration"
require "test_prof/autopilot/registry"
require "test_prof/autopilot/logging"
require "test_prof/autopilot/dsl"
require "fileutils"

module TestProf
  module Autopilot
    class Runner
      prepend Dsl

      attr_reader :report

      class << self
        def invoke(plan_path, command)
          Autopilot.configure do |config|
            config.plan_path = plan_path
            config.command = command
          end

          Logging.log "Reading #{plan_path}..."

          new.instance_eval(File.read(Autopilot.config.plan_path))
        end
      end
    end
  end
end
