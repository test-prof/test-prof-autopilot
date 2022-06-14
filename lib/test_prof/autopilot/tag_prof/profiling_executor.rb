# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor/base"

module TestProf
  module Autopilot
    module TagProf
      # Provides :tag_prof specific validations, env and command building.
      class ProfilingExecutor < ProfilingExecutor::Base
        Registry.register(:tag_prof_executor, self)

        def initialize(options)
          super
          @profiler = :tag_prof
        end

        private

        def validate_profiler!
          super
          @options[:event] = @options[:events].join(",") if @options[:events]
          @options[:tag] ||= "type"
        end

        def build_env
          super.tap do |env|
            env["TAG_PROF"] = @options[:tag]
            env["TAG_PROF_EVENT"] = @options[:event] if @options[:event]
          end
        end
      end
    end
  end
end
