# frozen_string_literal: true

module TestProf
  module Autopilot
    module Patches
      module FactoryDefaultPatch
        ARTIFACT_FILE = "factory_default_prof_report.json"

        module ProfilerExt
          def print_report
            # TODO: extract it into a method in TestProf
            data = self.data.each_with_object({}) do |(name, stats), acc|
              name = name.gsub(/\$id\$.+\$di\$/, "<id>")
              if acc.key?(name)
                acc[name][:count] += stats[:count]
                acc[name][:time] += stats[:time]
              else
                acc[name] = stats
              end
            end

            dir_path = FileUtils.mkdir_p(Autopilot.config.tmp_dir)[0]
            file_path = File.join(dir_path, ARTIFACT_FILE)

            File.write(file_path, data.to_json)
          end
        end

        def patch
          ::TestProf::FactoryDefault::Profiler.prepend(ProfilerExt)
        end

        module_function :patch
      end
    end
  end
end

if ENV["FACTORY_DEFAULT_ENABLED"] == "true"
  require "test_prof/factory_default"
  require "test_prof/recipes/rspec/factory_default"
  TestProf::Autopilot::Patches::FactoryDefaultPatch.patch
end
