# frozen_string_literal: true

require "json"
require "test_prof/autopilot/report_builder"

module TestProf
  module Autopilot
    module FactoryProf
      # :factory_prof report allows to add additional functionality
      # for it's instances
      class Report
        extend ReportBuilder

        ARTIFACT_PATH = "tmp/test_prof_autopilot/factory_prof_report.json"

        attr_reader :printer, :raw_report

        def initialize(raw_report)
          @printer = :factory_prof
          @raw_report = raw_report
        end
      end
    end
  end
end
