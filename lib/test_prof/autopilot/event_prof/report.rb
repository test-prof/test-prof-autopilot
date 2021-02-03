# frozen_string_literal: true

require "json"
require "test_prof/autopilot/report_builder"

module TestProf
  module Autopilot
    module EventProf
      class Report
        extend ReportBuilder

        ARTIFACT_PATH = "tmp/test_prof_autopilot/event_prof_report.json"

        attr_reader :profiler, :raw_report

        def initialize(raw_report)
          @profiler = :event_prof
          @raw_report = raw_report
        end

        def paths
          @raw_report["groups"].reduce("") { |paths, group| "#{paths} #{group["location"]}" }.strip
        end
      end
    end
  end
end
