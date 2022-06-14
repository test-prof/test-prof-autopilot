# frozen_string_literal: true

module TestProf
  module Autopilot
    class << self
      def config
        @config ||= Configuration.new
      end

      def configure
        yield config
      end
    end

    # Global configuration
    class Configuration
      attr_accessor :output,
        :tmp_dir,
        :artifacts_dir,
        :plan_path,
        :merge_format,
        :merge_file,
        :command

      def initialize
        @output = $stdout
        @tmp_dir = "tmp/test_prof_autopilot"
        @artifacts_dir = "test_prof_autopilot"
        @merge_format = "info"
      end
    end
  end
end
