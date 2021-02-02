# frozen_string_literal: true

require "test_prof/autopilot/profiling_executor"

module TestProf
  module Autopilot
    module Dsl
      def run(profiler, **options)
        executor = ProfilingExecutor.new(profiler, options).start

        @report = executor.report
      end

      def info(printable_object = nil)
        return Logging.log "Specify data to print: 'report'" if printable_object.nil?

        printable_object.print
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
