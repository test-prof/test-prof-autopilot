# frozen_string_literal: true

require "open3"
require "test_prof/autopilot/event_prof/report"
require "test_prof/autopilot/factory_prof/report"

module TestProf
  module Autopilot
    # Provides base command and env variables building;
    # Starts child process and executes command in it;
    # Builds report after child process is finished.
    class BaseProfilingExecutor
      attr_accessor :options
      attr_reader :report

      def initialize(options)
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

        env["SAMPLE"] = @options[:sample].to_s if @options[:sample]
        env
      end

      def build_command
        return Configuration.config.command if @options[:paths].nil?

        "#{Configuration.config.command} #{@options[:paths]}"
      end

      def build_report
        @report = Registry.fetch(:"#{@profiler}_report").build
      end
    end
  end
end
