# frozen_string_literal: true

aggregate(2) { run :stack_prof, sample: 100 }

info report
