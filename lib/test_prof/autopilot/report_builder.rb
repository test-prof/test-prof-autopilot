# frozen_string_literal: true

module TestProf
  module Autopilot
    module ReportBuilder
      def build
        raw_report = fetch_report

        new(raw_report)
      end

      private

      def fetch_report
        file = File.read(self::ARTIFACT_PATH)
        JSON.parse(file)
      end
    end
  end
end
