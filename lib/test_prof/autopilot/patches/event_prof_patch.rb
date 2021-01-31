require "test-prof"

module TestProf
  module Autopilot
    module Patches
      module EventProfPatch
        def patch
          TestProf::EventProf::RSpecListener.class_eval do
            def report(profiler)
              result = profiler.results

              profiler_hash = {
                event: profiler.event,
                total_time: profiler.total_time,
                absolute_run_time: profiler.absolute_run_time,
                total_count: profiler.total_count,
                top_count: profiler.top_count,
                rank_by: profiler.rank_by
              }

              profiler_hash[:groups] = result[:groups].map do |group|
                {
                  description: group[:id].top_level_description,
                  location: group[:id].metadata[:location],
                  time: group[:time],
                  run_time: group[:run_time],
                  time_percentage: time_percentage(group[:time], group[:run_time])
                }
              end

              dir_path = FileUtils.mkdir_p("tmp/test_prof_autopilot")[0]
              json_path = "#{dir_path}/event_prof_report.json"

              File.write(json_path, JSON.generate(profiler_hash))
            end
          end
        end

        module_function :patch
      end
    end
  end
end

TestProf::Autopilot::Patches::EventProfPatch.patch
