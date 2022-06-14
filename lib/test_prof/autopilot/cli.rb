# frozen_string_literal: true

require "optparse"
require "test_prof/autopilot/runner"
require "test_prof/autopilot/merger"

module TestProf
  module Autopilot
    class CLI
      attr_reader :command, :plan_path, :mode, :merge_type, :report_paths

      def run(args = ARGV)
        @mode = "runner"

        optparser.parse!(args)

        if mode == "runner"
          raise "Test command must be specified. See -h for options" unless command

          raise "Plan path must be specified. See -h for options" unless plan_path

          raise "Plan #{plan_path} doesn't exist" unless File.file?(plan_path)

          Runner.invoke(plan_path, command)
        elsif mode == "merger"
          raise "Report paths must be specified. See -h for options" unless report_paths

          Merger.invoke(merge_type, report_paths)
        end
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

          # Merger-specific options
          opts.on("--merge=TYPE", "Merge existing reports of the specified type") do |val|
            @mode = "merger"
            @merge_type = val
          end

          opts.on("--reports=PATH", "Reports path glob or comma-separated paths") do |val|
            @report_paths = val.split(",")
          end

          opts.on("--merge-format=FORMAT", "Combined report format") do |val|
            Autopilot.config.merge_format = val
          end

          opts.on("--merge-file=PATH", "Where to store combined report") do |val|
            Autopilot.config.merge_file = File.absolute_path?(val) ? val : File.expand_path(val)
          end
        end
      end
    end
  end
end
