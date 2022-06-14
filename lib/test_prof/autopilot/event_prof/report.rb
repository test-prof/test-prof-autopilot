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
      end
    end
  end
end
