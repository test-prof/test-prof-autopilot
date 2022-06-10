# frozen_string_literal: true

module TestProf
  module Autopilot
    # Global configuration
    class Configuration
      class << self
        def config
          @config ||= new
        end

        def configure
          yield config
        end
      end

      attr_accessor :output,
        :artifacts_dir,
        :plan_path,
        :command

      def initialize
        @output = $stdout
        @artifacts_dir = "tmp/test_prof_autopilot"
      end
    end
  end
end
