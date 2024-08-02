# frozen_string_literal: true

run :factory_default_prof

info report

report.factories.select { |_, v| v[:count] > 1 }.each do |name, stats|
  puts "#{name} - #{stats[:count]} times, #{stats[:time]}s"
end
