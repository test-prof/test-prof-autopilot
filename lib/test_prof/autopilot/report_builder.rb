# frozen_string_literal: true

module TestProf
  module Autopilot
    # Common module that extends reports classes
    module ReportBuilder
      ARTIFACT_MISSING_HINT = "Have you required 'test_prof/autopilot' to your code? "

      def build
        raw_report = fetch_report

        new(raw_report)
      end

      private

      def fetch_report
        file = File.read(self::ARTIFACT_PATH)
        JSON.parse(file)
      rescue Errno::ENOENT => e
        e.message.prepend(ARTIFACT_MISSING_HINT)
        raise
      end
    end
  end
end
