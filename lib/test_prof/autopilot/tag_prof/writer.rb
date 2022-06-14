# frozen_string_literal: true

require "test_prof/autopilot/report_writer"

module TestProf
  module Autopilot
    module TagProf
      # Class is used for writing :tag_prof report in different formats
      class Writer < ReportWriter
        Registry.register(:tag_prof_writer, self)

        ARTIFACT_FILE = "tag_prof_report"

        def generate_json
          report.result.to_json
        end
      end
    end
  end
end
