# frozen_string_literal: true

module TestProf
  module Autopilot
    module FactoryProf
      # Class is used for writing :factory_prof report in different formats
      class Writer < ReportWriter
        Registry.register(:factory_prof_writer, self)

        ARTIFACT_FILE = "factory_prof_report"

        def generate_json
          report.result.to_json
        end

        def generate_html
          result = report.result

          report_data = {
            total_stacks: result.stacks.size,
            total: result.total_count
          }

          report_data[:roots] = TestProf::FactoryProf::Printers::Flamegraph.convert_stacks(result)

          path = TestProf::Utils::HTMLBuilder.generate(
            data: report_data,
            template: TestProf::FactoryProf::Printers::Flamegraph::TEMPLATE,
            output: TestProf::FactoryProf::Printers::Flamegraph::OUTPUT_NAME
          )

          File.read(path).tap do
            FileUtils.rm(path)
          end
        end
      end
    end
  end
end
