# frozen_string_literal: true

module TestProf
  module Autopilot
    module StackProf
      # Module is used for printing :stack_prof report
      module Printer
        Registry.register(:stack_prof_printer, self)

        def print_report(report)
          report.print_text
        end

        module_function :print_report
      end
    end
  end
end
