# frozen_string_literal: true

module TestProf
  module Autopilot
    module Patches
      # Monkey-patch for 'TestProf::EventProf::RSpecListener'.
      # Redefined 'report' method provides writing artifact to the directory
      # instead of printing report
      module EventProfPatch
        ARTIFACT_FILE = "event_prof_report.json"

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
                rank_by: profiler.rank_by,
                time_percentage: time_percentage(profiler.total_time, profiler.absolute_run_time)
              }

              profiler_hash[:groups] = result[:groups].map do |group|
                {
                  description: group[:id].top_level_description,
                  location: group[:id].metadata[:location],
                  time: group[:time],
                  count: group[:count],
                  examples: group[:examples],
                  run_time: group[:run_time],
                  time_percentage: time_percentage(group[:time], group[:run_time])
                }
              end

              dir_path = FileUtils.mkdir_p(Configuration.config.tmp_dir)[0]
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

TestProf::Autopilot::Patches::EventProfPatch.patch
