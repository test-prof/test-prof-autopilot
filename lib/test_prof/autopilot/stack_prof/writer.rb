# frozen_string_literal: true

module TestProf
  module Autopilot
    module StackProf
      # Module is used for writing :stack_prof report in different formats
      module Writer
        Registry.register(:stack_prof_writer, self)

        ARTIFACT_FILE = "stack_prof_report"

        def write_report(report, file_name: ARTIFACT_FILE)
          dir_path = FileUtils.mkdir_p(Configuration.config.artifacts_dir)[0]
          file_path = File.join(dir_path, file_name + ".json")

          File.write(file_path, JSON.generate(report.data))
        end

        module_function :write_report
      end
    end
  end
end
