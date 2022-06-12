# frozen_string_literal: true

require "test_prof/autopilot/event_prof/printer"
require "test_prof/autopilot/event_prof/profiling_executor"

require "test_prof/autopilot/factory_prof/printer"
require "test_prof/autopilot/factory_prof/profiling_executor"

require "test_prof/autopilot/stack_prof/printer"
require "test_prof/autopilot/stack_prof/profiling_executor"

module TestProf
  module Autopilot
    # Module contains all available DSL instructions
    module Dsl
      # 'run' is used to start profiling
      # profiler – uniq name of profiler; available profilers – :event_prof, :factory_prof
      # options; available options – :sample, :paths and :event ('event_prof' profiler only)
      def run(profiler, **options)
        Logging.log "Executing 'run' with profiler:#{profiler} and options:#{options}"

        executor = Registry.fetch(:"#{profiler}_executor").new(options).start

        @report = executor.report
      end

      # 'info' prints report
      # printable_object; available printable objects – 'report'
      def info(printable_object)
        Registry.fetch(:"#{printable_object.printer}_printer").print_report(printable_object)
      end
    end
  end
end
