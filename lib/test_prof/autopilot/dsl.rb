module TestProf
  module Autopilot
    module Dsl
      def run(profiler, **options)
        raise NotImplementedError
      end

      def info
        raise NotImplementedError
      end

      def method_missing(method, *args)
        Runner.log "Sorry, '#{method}' instruction is not supported"
        Runner.log "Look to supported instructions: 'run', 'info'"
      end
    end
  end
end
