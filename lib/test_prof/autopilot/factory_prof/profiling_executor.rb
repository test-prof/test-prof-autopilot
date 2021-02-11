# frozen_string_literal: true

require "test_prof/autopilot/base_profiling_executor"

module TestProf
  module Autopilot
    module FactoryProf
      class ProfilingExecutor < BaseProfilingExecutor
        Registry.register(:factory_prof_executor, self)

        def initialize(options)
          super
          @profiler = :factory_prof
        end

        private

        def build_env
          super.tap do |env|
            env["FPROF"] = "1"
          end
        end
      end
    end
  end
end
