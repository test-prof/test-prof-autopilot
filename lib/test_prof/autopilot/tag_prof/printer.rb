# frozen_string_literal: true

require "test_prof"
require "test_prof/tag_prof/printers/simple"

module TestProf
  module Autopilot
    module TagProf
      # Module is used for printing :tag_prof report
      module Printer
        Registry.register(:tag_prof_printer, self)

        def print_report(report)
          TestProf::TagProf::Printers::Simple.dump(report.result)
        end

        module_function :print_report
      end
    end
  end
end
