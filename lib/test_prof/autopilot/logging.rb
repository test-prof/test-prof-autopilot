# frozen_string_literal: true

module TestProf
  module Autopilot
    module Logging
      def log(message)
        Autopilot.config.output.puts(message)
      end

      module_function :log
    end
  end
end
