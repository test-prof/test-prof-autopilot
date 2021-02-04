# frozen_string_literal: true

require "open3"
require "test_prof/autopilot/event_prof/report"
require "test_prof/autopilot/factory_prof/report"

module TestProf
  module Autopilot
    # Provides command and env variables building;
    # Starts child process and executes command in it;
    # Builds report after child process is finished.
    class ProfilingExecutor
      PROFILERS_REPORTS = {
        event_prof: "EventProf::Report",
        factory_prof: "FactoryProf::Report"
      }.freeze

      attr_accessor :profiler, :options
      attr_reader :report

      def initialize(profiler, options)
        @profiler = profiler
        @options = options
      end

      def start
        validate_profiler!

        execute
        build_report

        self
      end

      private

      def validate_profiler!
        unless PROFILERS_REPORTS.key?(@profiler)
          raise ArgumentError, "Unknown profiler: #{@profiler}. Valid providers: #{PROFILERS_REPORTS.keys.join(", ")}"
        end

        if @profiler == :event_prof && @options[:event].nil?
          raise ArgumentError, "'event' option is required for '#{@profiler}' profiler"
        end
      end

      def execute
        env = build_env
        command = build_command

        Open3.popen2e(env, command) do |_stdin, stdout_and_stderr, _wait_thr|
          while (line = stdout_and_stderr.gets)
            Logging.log line
          end
        end
      end

      def build_env
        env = {}

        env["EVENT_PROF"] = @options[:event] if @profiler == :event_prof
        env["FPROF"] = "1" if @profiler == :factory_prof
        env["SAMPLE"] = @options[:sample].to_s if @options[:sample]

        env
      end

      def build_command
        return Runner.config.command if @options[:paths].nil?

        "#{Runner.config.command} #{@options[:paths]}"
      end

      def build_report
        @report = ::TestProf::Autopilot.const_get(PROFILERS_REPORTS[profiler]).build
      end
    end
  end
end
