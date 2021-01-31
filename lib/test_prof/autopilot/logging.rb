# frozen_string_literal: true

module TestProf
  module Autopilot
    module Logging
      def log(message)
        Runner.config.output.puts(message)
      end
    end
  end
end
