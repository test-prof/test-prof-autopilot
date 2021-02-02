# frozen_string_literal: true

require "open3"
require "test_prof/autopilot/event_prof/report"
require "test_prof/autopilot/factory_prof/report"

module TestProf
  module Autopilot
    class ProfilingExecutor
      PROFILERS_REPORTS = {
        event_prof: "EventProf::Report",
        factory_prof: "FactoryProf::Report"
      }.freeze

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
        build_report if success?

        self
      end

      private

      def validate_profiler!
        return if PROFILERS_REPORTS.key?(@profiler)

        raise ArgumentError, "Unknown profiler: #{@profiler}. Valid providers: #{PROFILERS_REPORTS.keys.join(", ")}"
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

      def build_report
        @report = ::TestProf::Autopilot.const_get(PROFILERS_REPORTS[profiler]).build
      end
    end
  end
end
