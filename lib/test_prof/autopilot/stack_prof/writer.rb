# frozen_string_literal: true

require "test_prof/autopilot/report_writer"

module TestProf
  module Autopilot
    module StackProf
      # Class is used for writing :stack_prof report in different formats
      class Writer < ReportWriter
        Registry.register(:stack_prof_writer, self)

        ARTIFACT_FILE = "stack_prof_report"

        def generate_json
          JSON.generate(report.data)
        end
      end
    end
  end
end
