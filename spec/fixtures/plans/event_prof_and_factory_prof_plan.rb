# frozen_string_literal: true

run :event_prof, event: "factory.create"
run :factory_prof, paths: report.paths

info report
