# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor/base"

module TestProf
  module Autopilot
    module StackProf
      # Provides :stack_prof specific validations, env and command building.
      class ProfilingExecutor < ProfilingExecutor::Base
        Registry.register(:stack_prof_executor, self)

        def initialize(options)
          super
          @profiler = :stack_prof
        end

        private

        def build_env
          super.tap do |env|
            env["TEST_STACK_PROF"] = @options[:boot] ? "boot" : "1"
          end
        end
      end
    end
  end
end
