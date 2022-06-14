# frozen_string_literal: true

require "json"
require "test_prof/autopilot/report_builder"

module TestProf
  module Autopilot
    module EventProf
      # :event_prof report allows to add additional functionality
      # for it's instances
      class Report
        Registry.register(:event_prof_report, self)

        extend ReportBuilder

        ARTIFACT_FILE = "event_prof_report.json"

        attr_reader :type, :raw_report

        def initialize(raw_report)
          @type = :event_prof
          @raw_report = raw_report
        end

        def paths
          @raw_report["groups"].reduce("") { |paths, group| "#{paths} #{group["location"]}" }.strip
        end

        def merge(other)
          raise ArgumentError, "Incompatible events: #{raw_report["event"]} and #{other.raw_report["event"]}" if raw_report["event"] != other.raw_report["event"]

          report = raw_report.dup

          %w[total_time absolute_run_time total_count].each do |field|
            report[field] += other.raw_report[field]
          end

          report["time_percentage"] = (report["total_time"] / report["absolute_run_time"]) * 100

          report["groups"] = (report["groups"] + other.raw_report["groups"]).sort { |a, b| b["time"] <=> a["time"] }.take(report["top_count"])

          Report.new(report)
        end
      end
    end
  end
end
