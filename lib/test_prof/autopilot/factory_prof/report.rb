# frozen_string_literal: true

require "json"
require "test_prof/autopilot/report_builder"

module TestProf
  module Autopilot
    module FactoryProf
      # :factory_prof report allows to add additional functionality
      # for it's instances
      class Report
        Registry.register(:factory_prof_report, self)

        extend ReportBuilder

        ARTIFACT_FILE = "factory_prof_report.json"

        attr_reader :type, :raw_report

        def initialize(raw_report)
          @type = :factory_prof
          @raw_report = raw_report
        end

        def result
          @result ||= TestProf::FactoryProf::Result.new(
            raw_report["stacks"],
            raw_report["raw_stats"].transform_values! { |stats| stats.transform_keys!(&:to_sym) }
          )
        end

        def merge(other)
          report = raw_report.dup

          report["stacks"] += other.raw_report["stacks"] if report["stacks"]

          (report["raw_stats"].values + other.raw_report["raw_stats"].values).each_with_object({}) do |data, acc|
            if acc.key?(data["name"])
              current = acc[data["name"]]

              current["total_count"] += data["total_count"]
              current["top_level_count"] += data["top_level_count"]
              current["total_time"] += data["total_time"]
              current["top_level_time"] += data["top_level_time"]
            else
              acc[data["name"]] = data.dup
            end
          end.then do |stats|
            report["raw_stats"] = stats
          end

          Report.new(report)
        end
      end
    end
  end
end
