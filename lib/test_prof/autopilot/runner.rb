# frozen_string_literal: true

require "test_prof/autopilot/logging"
require "test_prof/autopilot/dsl"

module TestProf
  module Autopilot
    class Runner
      prepend Dsl

      attr_reader :report

      class << self
        attr_reader :config

        def invoke(plan_path, command)
          @config = Configuration.new(plan_path, command)

          new.instance_eval(File.read(config.plan_path))
        end
      end

      class Configuration
        attr_accessor :plan_path,
          :command,
          :output

        def initialize(plan_path, command)
          @plan_path = plan_path
          @command = command

          @output = $stdout
        end
      end
    end
  end
end
