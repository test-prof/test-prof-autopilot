# frozen_string_literal: true

module TestProf
  module Autopilot
    # Common module that extends reports classes
    module ReportBuilder
      ARTIFACT_MISSING_HINT = "Have you required 'test_prof/autopilot' to your code? "

      def build
        report = JSON.parse(fetch_report)

        new(report)
      end

      private

      def fetch_report
        file_path = File.join(Configuration.config.artifacts_dir, self::ARTIFACT_FILE)
        File.read(file_path)
      rescue Errno::ENOENT => e
        e.message.prepend(ARTIFACT_MISSING_HINT)
        raise
      end
    end
  end
end
