# frozen_string_literal: true

module TestProf
  module Autopilot
    module FactoryDefault
      # Module is used for printing :factory_prof report
      module Printer
        Registry.register(:factory_default_prof_printer, self)

        class PrinterError < StandardError; end

        def print_report(report)
          result = report.result

          require "test_prof/factory_default"
          profiler = TestProf::FactoryDefault::Profiler.new
          profiler.data.merge!(result)
          profiler.print_report
        end

        module_function :print_report
      end
    end
  end
end
