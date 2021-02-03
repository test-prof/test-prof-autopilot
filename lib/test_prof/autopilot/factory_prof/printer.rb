# frozen_string_literal: true

require "test_prof/autopilot/logging"

module TestProf
  module Autopilot
    module FactoryProf
      module Printer
        class PrinterError < StandardError; end

        def print_report(report)
          result = report.raw_report

          raise PrinterError, result["error"] if result["error"]

          msgs = []

          msgs <<
            <<~MSG
              Factories usage

               Total: #{result["total_count"]}
               Total top-level: #{result["total_top_level_count"]}
               Total time: #{format("%.4f", result["total_time"])}s
               Total uniq factories: #{result["total_uniq_factories"]}

                 total   top-level     total time      time per call      top-level time               name
            MSG

          result["stats"].each do |stat|
            time_per_call = stat["total_time"] / stat["total_count"]

            msgs << format("%8d %11d %13.4fs %17.4fs %18.4fs %18s", stat["total_count"], stat["top_level_count"], stat["total_time"], time_per_call, stat["top_level_time"], stat["name"])
          end

          Logging.log msgs.join("\n")
        end

        module_function :print_report
      end
    end
  end
end
