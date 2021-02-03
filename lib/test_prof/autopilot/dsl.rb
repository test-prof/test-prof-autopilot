# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor"
require "test_prof/autopilot/event_prof/printer"
require "test_prof/autopilot/factory_prof/printer"

module TestProf
  module Autopilot
    module Dsl
      def run(profiler, **options)
        Logging.log "Executing 'run' with profiler:#{profiler} and options:#{options}"

        executor = ProfilingExecutor.new(profiler, options).start

        @report = executor.report
      end

      def info(printable_object = nil)
        raise ArgumentError, "Specify printable object to print" if printable_object.nil?

        TestProf::Autopilot.const_get(Runner::PRINTERS[printable_object.printer]).print_report(printable_object)
      end
    end
  end
end
