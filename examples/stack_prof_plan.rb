# frozen_string_literal: true

# First, profile the boot time
run :stack_prof, boot: true, sample: 10

save report, file_name: "stack_prof_boot"

# Then, generate multiple sampled profiles and aggregate the results
aggregate(3) { run :stack_prof, sample: 100 }

save report, file_name: "stack_prof_sample"
