# frozen_string_literal: true

module TestProf
  module Autopilot
    module Patches
      # Monkey-patch for 'TestProf::TagProf::RSpecListener'.
      # Redefined 'report' method provides writing artifact to the directory
      # instead of printing report
      module TagProfPatch
        ARTIFACT_FILE = "tag_prof_report.json"

        def patch
          TestProf::TagProf::RSpecListener.class_eval do
            def report
              dir_path = FileUtils.mkdir_p(Autopilot.config.tmp_dir)[0]
              file_path = File.join(dir_path, ARTIFACT_FILE)

              File.write(file_path, result.to_json)
            end
          end
        end

        module_function :patch
      end
    end
  end
end

TestProf::Autopilot::Patches::TagProfPatch.patch
