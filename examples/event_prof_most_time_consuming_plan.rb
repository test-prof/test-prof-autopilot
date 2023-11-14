run :event_prof, event: "factory.create", top_count: 1000

total_run_time = report.raw_report["absolute_run_time"]
total_event_time = report.raw_report["total_time"]

# Select test files that take 50% of total run time
threshold = 0.5 * total_run_time

sum = 0.0
sum_event = 0.0

top_groups = report.raw_report["groups"].take_while do |group|
  next false unless sum < threshold

  sum += group["run_time"]
  sum_event += group["time"]
  true
end

msg = <<~TXT
  Total groups: #{report.raw_report["groups"].size}
  Total times: #{total_event_time} / #{total_run_time}
  Selected groups: #{top_groups.size}
  Selected times: #{sum_event} / #{sum}

  Paths:

TXT

paths = top_groups.map { _1["location"] }

puts msg
puts paths.join("\n")
