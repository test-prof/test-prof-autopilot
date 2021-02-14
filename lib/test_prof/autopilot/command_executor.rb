# frozen_string_literal: true

require "open3"

module TestProf
  module Autopilot
    # Module is used for commands execution in child process.
    module CommandExecutor
      def execute(env, command)
        Open3.popen2e(env, command) do |_stdin, stdout_and_stderr, _wait_thr|
          while (line = stdout_and_stderr.gets)
            Logging.log line
          end
        end
      end

      module_function :execute
    end
  end
end
