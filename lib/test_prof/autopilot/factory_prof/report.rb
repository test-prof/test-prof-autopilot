# frozen_string_literal: true

require "json"
require "test_prof/autopilot/report_builder"

module TestProf
  module Autopilot
    module FactoryProf
      # :factory_prof report allows to add additional functionality
      # for it's instances
      class Report
        Registry.register(:factory_prof_report, self)

        extend ReportBuilder

        ARTIFACT_FILE = "factory_prof_report.json"

        attr_reader :type, :raw_report

        def initialize(raw_report)
          @type = :factory_prof
          @raw_report = raw_report
        end

        def merge(other)
          report = raw_report.dup

          %w[total stacks].each do |field|
            report[field] += other.raw_report[field]
          end

          Report.new(report)
        end
      end
    end
  end
end
