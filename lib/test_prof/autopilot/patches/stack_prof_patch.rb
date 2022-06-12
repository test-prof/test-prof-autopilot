# frozen_string_literal: true

module TestProf
  module Autopilot
    module Patches
      module StackProfPatch
        ARTIFACT_FILE = "stack_prof_report.dump"

        def patch
          TestProf::StackProf.module_eval do
            private

            def self.build_path(_name)
              dir_path = FileUtils.mkdir_p(Configuration.config.artifacts_dir)[0]
              File.join(dir_path, ARTIFACT_FILE)
            end
          end
        end

        module_function :patch
      end
    end
  end
end

TestProf::Autopilot::Patches::StackProfPatch.patch
