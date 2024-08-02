# frozen_string_literal: true

require "test_prof/autopilot/event_prof/printer"
require "test_prof/autopilot/event_prof/profiling_executor"
require "test_prof/autopilot/event_prof/writer"

require "test_prof/autopilot/tag_prof/printer"
require "test_prof/autopilot/tag_prof/profiling_executor"
require "test_prof/autopilot/tag_prof/writer"

require "test_prof/autopilot/factory_prof/printer"
require "test_prof/autopilot/factory_prof/writer"
require "test_prof/autopilot/factory_prof/profiling_executor"

require "test_prof/autopilot/stack_prof/printer"
require "test_prof/autopilot/stack_prof/writer"
require "test_prof/autopilot/stack_prof/profiling_executor"

require "test_prof/autopilot/factory_default/printer"
require "test_prof/autopilot/factory_default/writer"
require "test_prof/autopilot/factory_default/profiling_executor"

module TestProf
  module Autopilot
    # Module contains all available DSL instructions
    module Dsl
      # 'run' is used to start profiling
      # profiler – uniq name of profiler; available profilers – :event_prof, :factory_prof, :stack_prof
      # options; available options – :sample, :paths and :event ('event_prof' profiler only)
      def run(profiler, **options)
        Logging.log "Executing 'run' with profiler:#{profiler} and options:#{options}"

        executor = Registry.fetch(:"#{profiler}_executor").new(options).start

        @report = executor.report
      end

      # 'aggregate' is used to run one profiler several times and merge results
      # supported profilers – 'stack_prof'
      #
      # example of using:
      # aggregate(3) { run :stack_prof, sample: 100 }
      def aggregate(number, &block)
        raise ArgumentError, "Block is required!" unless block

        agg_report = nil

        number.times do
          block.call

          agg_report = agg_report.nil? ? report : agg_report.merge(report)
        end

        @report = agg_report
      end

      # 'info' prints report
      # printable_object; available printable objects – 'report'
      def info(printable_object)
        Registry.fetch(:"#{printable_object.type}_printer").print_report(printable_object)
      end

      # 'save' writes report to file
      def save(report, **options)
        Registry.fetch(:"#{report.type}_writer").write_report(report, **options)
      end
    end
  end
end
