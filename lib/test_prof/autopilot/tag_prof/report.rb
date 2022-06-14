# frozen_string_literal: true

require "json"
require "test_prof/autopilot/report_builder"
require "test_prof/tag_prof/result"

module TestProf
  module Autopilot
    module TagProf
      # :tag_prof report allows to add additional functionality
      # for it's instances
      class Report
        Registry.register(:tag_prof_report, self)

        extend ReportBuilder

        ARTIFACT_FILE = "tag_prof_report.json"

        SYMBOLIC_DATA_KEYS = %w[value count time].freeze

        attr_reader :type, :raw_report

        def initialize(raw_report)
          @type = :tag_prof
          @raw_report = raw_report
        end

        def result
          @result ||= TestProf::TagProf::Result.new(raw_report["tag"], raw_report["events"]).tap do |result|
            raw_report["data"].each do |tag_data|
              result.data[tag_data["value"]] = tag_data.transform_keys! do |key|
                SYMBOLIC_DATA_KEYS.include?(key) ? key.to_sym : key
              end
            end
          end
        end

        def merge(other)
          # TODO
        end
      end
    end
  end
end
