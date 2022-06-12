# frozen_string_literal: true

require "stackprof/report"

module TestProf
  module Autopilot
    module StackProf
      class Report < ::StackProf::Report
        Registry.register(:stack_prof_report, self)

        extend ReportBuilder

        ARTIFACT_FILE = "stack_prof_report.dump"

        attr_reader :printer

        def initialize(data)
          @printer = :stack_prof
          super(data)
        end

        def self.build
          new(Marshal.load(fetch_report))
        end

        def merge(other)
          self + other
        end
      end
    end
  end
end
