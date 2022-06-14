# frozen_string_literal: true

module TestProf
  module Autopilot
    module Patches
      # Monkey-patch for 'TestProf::FactoryProf::Printers::Simple'.
      # Redefined 'report' method provides writing artifact to the directory
      # instead of printing report
      module FactoryProfPatch
        ARTIFACT_FILE = "factory_prof_report.json"

        def patch
          TestProf::FactoryProf::Printers::Simple.module_eval do
            def self.dump(result, **)
              profiler_hash =
                if result.raw_stats == {}
                  {
                    error: "No factories detected"
                  }
                else
                  {
                    total_count: result.stats.sum { |stat| stat[:total_count] },
                    total_top_level_count: result.stats.sum { |stat| stat[:top_level_count] },
                    total_time: result.stats.sum { |stat| stat[:top_level_time] },
                    total_uniq_factories: result.stats.uniq { |stat| stat[:name] }.count,
                    stats: result.stats
                  }
                end

              dir_path = FileUtils.mkdir_p(Autopilot.config.tmp_dir)[0]
              file_path = File.join(dir_path, ARTIFACT_FILE)

              File.write(file_path, JSON.generate(profiler_hash))
            end
          end

          TestProf::FactoryProf::Printers::Flamegraph.module_eval do
            def self.dump(result, **)
              profiler_hash =
                if result.raw_stats == {}
                  {
                    error: "No factories detected"
                  }
                else
                  {
                    total_stacks: result.stacks.size,
                    total: result.total_count,
                    roots: convert_stacks(result)
                  }
                end

              dir_path = FileUtils.mkdir_p(Autopilot.config.tmp_dir)[0]
              file_path = File.join(dir_path, ARTIFACT_FILE)

              File.write(file_path, JSON.generate(profiler_hash))
            end
          end
        end

        module_function :patch
      end
    end
  end
end

TestProf::Autopilot::Patches::FactoryProfPatch.patch
