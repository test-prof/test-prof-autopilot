# frozen_string_literal: true

require "test_prof/autopilot/command_executor"
require "test_prof/autopilot/event_prof/report"
require "test_prof/autopilot/factory_prof/report"

module TestProf
  module Autopilot
    module ProfilingExecutor
      # Provides base command and env variables building;
      # Calls command executor;
      # Builds report.
      class Base
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

          CommandExecutor.execute(env, command)
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
end
