require "test-prof"

module TestProf
  module Autopilot
    module Patches
      module FactoryProfPatch
        def patch
          TestProf::FactoryProf::Printers::Simple.module_eval do
            def self.dump(result)
              profiler_hash =
                if result.raw_stats == {}
                  {
                    error_message: "No factories detected"
                  }
                else
                  {
                    total_count: result.stats.sum { |stat| stat[:total_count] },
                    total_top_level_count: result.stats.sum { |stat| stat[:top_level_count] },
                    total_time: result.stats.sum { |stat| stat[:top_level_time] },
                    total_uniq_factories: result.stats.map { |stat| stat[:name] }.uniq.count,
                    stats: result.stats
                  }
                end

              dir_path = FileUtils.mkdir_p("tmp/test_prof_autopilot")[0]
              json_path = "#{dir_path}/factory_prof_report.json"

              File.write(json_path, JSON.generate(profiler_hash))
            end
          end
        end

        module_function :patch
      end
    end
  end
end

TestProf::Autopilot::Patches::FactoryProfPatch.patch
