# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor/base"

module TestProf
  module Autopilot
    module FactoryDefault
      # Provides :factory_default_prof specific validations, env and command building.
      class ProfilingExecutor < ProfilingExecutor::Base
        Registry.register(:factory_default_prof_executor, self)

        def initialize(options)
          super
          @profiler = :factory_default_prof
        end

        private

        def build_env
          super.tap do |env|
            env["FACTORY_DEFAULT_ENABLED"] = "true"
            env["FACTORY_DEFAULT_PROF"] = "1"
          end
        end
      end
    end
  end
end
