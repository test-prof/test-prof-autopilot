# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor"
require "test_prof/autopilot/event_prof/printer"
require "test_prof/autopilot/factory_prof/printer"

module TestProf
  module Autopilot
    module Dsl
      def run(profiler, **options)
        executor = ProfilingExecutor.new(profiler, options).start

        @report = executor.report
      end

      def info(printable_object = nil)
        return Logging.log "Specify data to print: 'report'" if printable_object.nil?

        TestProf::Autopilot.const_get(Runner::PRINTERS[printable_object.printer]).print_report(printable_object)
      end

      def method_missing(method, *_args)
        Logging.log(
          <<~MSG
            '#{method}' instruction is not supported.

            Look to supported instructions: 'run', 'info'.
          MSG
        )
      end
    end
  end
end
