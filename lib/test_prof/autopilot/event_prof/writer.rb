# frozen_string_literal: true

module TestProf
  module Autopilot
    module EventProf
      # Module is used for writing :event_prof report in different formats
      module Writer
        Registry.register(:event_prof_writer, self)

        ARTIFACT_FILE = "event_prof_report"

        def write_report(report, file_name: ARTIFACT_FILE)
          dir_path = FileUtils.mkdir_p(Autopilot.config.artifacts_dir)[0]
          file_path = File.join(dir_path, file_name + ".json")

          File.write(file_path, JSON.generate(report.raw_report))

          Logging.log "EventProf report saved: #{file_path}"
        end

        module_function :write_report
      end
    end
  end
end
