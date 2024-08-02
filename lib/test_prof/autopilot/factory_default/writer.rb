# frozen_string_literal: true

module TestProf
  module Autopilot
    module FactoryDefault
      # Class is used for writing :factory_prof report in different formats
      class Writer < ReportWriter
        Registry.register(:factory_default_prof_writer, self)

        ARTIFACT_FILE = "factory_default_prof_report"

        def generate_json
          report.result.to_json
        end
      end
    end
  end
end
