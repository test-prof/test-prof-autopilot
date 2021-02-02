# frozen_string_literal: true

require 'json'

module TestProf
  module Autopilot
    module EventProf
      class Report
        ARTIFACT_PATH = "tmp/test_prof_autopilot/event_prof_report.json"

        class << self
          def build
            raw_report = fetch_report

            new(raw_report)
          end

          private

          def fetch_report
            file = File.read(ARTIFACT_PATH)
            JSON.parse(file)
          end
        end

        attr_reader :profiler, :raw_report

        def initialize(raw_report)
          @profiler = :event_prof
          @raw_report = raw_report
        end

        def paths
          @raw_report['groups'].map { |group| group['location'] }
        end
      end
    end
  end
end
