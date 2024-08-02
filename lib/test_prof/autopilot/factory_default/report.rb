# frozen_string_literal: true

require "json"
require "test_prof/autopilot/report_builder"

module TestProf
  module Autopilot
    module FactoryDefault
      class Report
        Registry.register(:factory_default_prof_report, self)

        extend ReportBuilder

        ARTIFACT_FILE = "factory_default_prof_report.json"

        attr_reader :type, :raw_report

        def initialize(raw_report)
          @type = :factory_default_prof
          @raw_report = raw_report
        end

        def result
          @result ||= raw_report.tap { |r| r.transform_values! { |v| v.transform_keys!(&:to_sym) } }
        end

        def factories
          result.dup
        end

        def merge(other)
          report = result.dup

          other.result.each do |name, stats|
            if result.key?(name)
              report[name][:count] += stats[:count]
              report[name][:time] += stats[:time]
            else
              report[name] = stats
            end
          end

          Report.new(report)
        end
      end
    end
  end
end
