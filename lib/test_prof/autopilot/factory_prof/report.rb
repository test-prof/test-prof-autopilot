# frozen_string_literal: true

require 'json'

module TestProf
  module Autopilot
    module FactoryProf
      class Report
        ARTIFACT_PATH = "tmp/test_prof_autopilot/factory_prof_report.json"

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
          @profiler = :factory_prof
          @raw_report = raw_report
        end
      end
    end
  end
end
