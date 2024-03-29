# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor/base"

module TestProf
  module Autopilot
    module FactoryProf
      # Provides :factory_prof specific validations, env and command building.
      class ProfilingExecutor < ProfilingExecutor::Base
        Registry.register(:factory_prof_executor, self)

        def initialize(options)
          super
          @profiler = :factory_prof
        end

        private

        def build_env
          super.tap do |env|
            env["FPROF"] = @options[:flamegraph] ? "flamegraph" : "1"
          end
        end
      end
    end
  end
end
