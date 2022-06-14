# frozen_string_literal: true

require "test_prof/autopilot/report_writer"
require "test_prof/tag_prof/printers/html"

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

        def generate_html
          path = TestProf::Utils::HTMLBuilder.generate(
            data: report.result,
            template: TestProf::TagProf::Printers::HTML::TEMPLATE,
            output: TestProf::TagProf::Printers::HTML::OUTPUT_NAME
          )

          File.read(path).tap do
            FileUtils.rm(path)
          end
        end
      end
    end
  end
end
