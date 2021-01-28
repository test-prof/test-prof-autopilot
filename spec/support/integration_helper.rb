# frozen_string_literal: true

require "open3"

module IntegrationHelper
  def run_command(command, chdir: File.expand_path("../..", __dir__), should_fail: false, env: {})
    output, err, status =
      Open3.capture3(
        env,
        command,
        chdir: chdir
      )

    if ENV["COMMAND_DEBUG"] || (!status.success? && !should_fail)
      puts "\n\nCOMMAND:\n#{command}\n\nOUTPUT:\n#{output}\nERROR:\n#{err}\n"
    end

    expect(status).to be_success unless should_fail
    expect(status).not_to be_success if should_fail

    yield output, err, status if block_given?
  end
end

RSpec.configure do |config|
  config.include IntegrationHelper
end
