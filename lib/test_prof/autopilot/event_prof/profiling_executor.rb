# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor/base"

module TestProf
  module Autopilot
    module EventProf
      class ProfilingExecutor < ProfilingExecutor::Base
        Registry.register(:event_prof_executor, self)

        def initialize(options)
          super
          @profiler = :event_prof
        end

        private

        def validate_profiler!
          super

          raise ArgumentError, "'event' option is required for 'event_prof' profiler" if @options[:event].nil?
        end

        def build_env
          super.tap do |env|
            env["EVENT_PROF"] = @options[:event]
          end
        end
      end
    end
  end
end
