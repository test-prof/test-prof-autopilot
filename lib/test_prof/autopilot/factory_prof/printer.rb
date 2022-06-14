# frozen_string_literal: true

module TestProf
  module Autopilot
    module FactoryProf
      # Module is used for printing :factory_prof report
      module Printer
        Registry.register(:factory_prof_printer, self)

        class PrinterError < StandardError; end

        def print_report(report)
          result = report.result

          # TODO: Move total_time to the report
          TestProf::FactoryProf::Printers::Simple.dump(result, start_time: TestProf.now)
        end

        module_function :print_report
      end
    end
  end
end
