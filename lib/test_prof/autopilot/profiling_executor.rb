# frozen_string_literal: true

require "open3"

module TestProf
  module Autopilot
    class ProfilingExecutor
      PROFILERS = %i[event_prof factory_prof].freeze

      attr_accessor :profiler, :options
      attr_reader :report, :success
      alias_method :success?, :success

      def initialize(profiler, options)
        @profiler = profiler
        @options = options

        @success = false
      end

      def start
        validate_profiler!

        execute
        generate_report if success?

        self
      end

      private

      def validate_profiler!
        return if PROFILERS.include?(@profiler)

        raise ArgumentError, "Unknown profiler: #{@profiler}. Valid providers: #{PROFILERS.join(", ")}"
      end

      def execute
        env = build_env

        @success =
          Open3.popen2e(env, Runner.config.command) do |_stdin, stdout_and_stderr, wait_thr|
            while (line = stdout_and_stderr.gets)
              Logging.log line
            end

            wait_thr.value.success?
          end
      end

      def build_env
        env = {}

        env["EVENT_PROF"] = @options[:event] if @profiler == :event_prof && @options[:event]
        env["FPROF"] = "1" if @profiler == :factory_prof
        env
      end

      def generate_report
      end
    end
  end
end
