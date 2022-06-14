# frozen_string_literal: true

require "test_prof/autopilot/configuration"
require "test_prof/autopilot/registry"
require "test_prof/autopilot/logging"
require "test_prof/autopilot/dsl"
require "fileutils"

module TestProf
  module Autopilot
    class Merger
      prepend Dsl

      class << self
        def invoke(type, paths)
          Logging.log "Merging #{type} reports at #{paths.join(", ")}..."

          paths = paths.flat_map(&Dir.method(:glob))

          new(type, paths).print_report
        end
      end

      attr_reader :type, :report_class, :paths

      def initialize(type, paths)
        @type = type
        @paths = paths
        @report_class = Registry.fetch(:"#{type}_report")
      end

      def print_report
        format = Autopilot.config.merge_format
        if format == "info"
          info agg_report
        else
          save agg_report, format: format, file_name: Autopilot.config.merge_file
        end
      end

      private

      def agg_report
        return @agg_report if instance_variable_defined?(:@agg_report)

        initial = report_class.new(JSON.parse(File.read(paths.pop)))

        paths.reduce(initial) do |acc, path|
          report = report_class.new(JSON.parse(File.read(path)))

          acc.merge(report)
        end
      end
    end
  end
end
