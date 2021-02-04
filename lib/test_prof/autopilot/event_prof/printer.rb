# frozen_string_literal: true

require "test_prof/autopilot/logging"
require "test_prof/ext/float_duration"
require "test_prof/ext/string_truncate"

module TestProf
  module Autopilot
    module EventProf
      # Module is used for printing :event_prof report
      module Printer
        using FloatDuration
        using StringTruncate

        def print_report(report)
          result = report.raw_report
          msgs = []

          msgs <<
            <<~MSG
              EventProf results for #{result["event"]}
  
              Total time: #{result["total_time"].duration} of #{result["absolute_run_time"].duration} (#{result["time_percentage"]}%)
              Total events: #{result["total_count"]}
  
              Top #{result["top_count"]} slowest suites (by #{result["rank_by"]}):
            MSG

          result["groups"].each do |group|
            msgs <<
              <<~GROUP
                #{group["description"].truncate} (#{group["location"]}) – #{group["time"].duration} (#{group["count"]} / #{group["examples"]}) of #{group["run_time"].duration} (#{group["time_percentage"]}%)
              GROUP
          end

          Logging.log msgs.join
        end

        module_function :print_report
      end
    end
  end
end
