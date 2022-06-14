# frozen_string_literal: true

require "test_prof/autopilot/report_writer"

module TestProf
  module Autopilot
    module EventProf
      # Class is used for writing :event_prof report in different formats
      class Writer < ReportWriter
        Registry.register(:event_prof_writer, self)

        ARTIFACT_FILE = "event_prof_report"

        def generate_json
          JSON.generate(report.raw_report)
        end
      end
    end
  end
end
