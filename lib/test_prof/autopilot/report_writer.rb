# frozen_string_literal: true

module TestProf
  module Autopilot
    # Base class for report writers classes
    class ReportWriter
      include Logging

      class << self
        def write_report(report, **options)
          new(report).write(**options)
        end
      end

      attr_reader :report

      def initialize(report)
        @report = report
      end

      def write(file_name: nil, format: "json")
        file_path = file_name || self.class::ARTIFACT_FILE

        unless File.absolute_path?(file_path)
          dir_path = FileUtils.mkdir_p(Autopilot.config.artifacts_dir)[0]
          file_path = File.join(dir_path, file_path + ".#{format}")
        end

        File.write(file_path, public_send("generate_#{format}"))

        log "Report saved: #{file_path}"
      end

      def generate_json
      end
    end
  end
end
