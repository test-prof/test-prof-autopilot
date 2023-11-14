# frozen_string_literal: true

run :event_prof, event: "factory.create", top_count: 2, rank_by: :count

info report
