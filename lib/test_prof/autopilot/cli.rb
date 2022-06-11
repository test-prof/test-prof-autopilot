# frozen_string_literal: true

require "optparse"
require "test_prof/autopilot/runner"

module TestProf
  module Autopilot
    class CLI
      attr_reader :command, :plan_path

      def run(args = ARGV)
        optparser.parse!(args)

        raise "Test command must be specified. See -h for options" unless command

        raise "Plan path must be specified. See -h for options" unless plan_path

        raise "Plan #{plan_path} doesn't exist" unless File.file?(plan_path)

        Runner.invoke(plan_path, command)
      end

      private

      def optparser
        @optparser ||= OptionParser.new do |opts|
          opts.banner = "Usage: auto-test-prof [options]"

          opts.on("-v", "--version", "Print version") do
            $stdout.puts TestProf::Autopilot::VERSION
            exit 0
          end

          opts.on("-c COMMAND", "--command", "Command to run tests") do |val|
            @command = val
          end

          opts.on("-i FILE", "--plan", "Path to test plan") do |val|
            @plan_path = val
          end
        end
      end
    end
  end
end
