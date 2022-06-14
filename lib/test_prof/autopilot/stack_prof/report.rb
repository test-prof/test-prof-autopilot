# frozen_string_literal: true

require "stackprof/report"

module TestProf
  module Autopilot
    module StackProf
      class Report < ::StackProf::Report
        Registry.register(:stack_prof_report, self)

        extend ReportBuilder

        ARTIFACT_FILE = "stack_prof_report.dump"

        attr_reader :type

        def initialize(data)
          @type = :stack_prof
          super(data)
        end

        def self.build
          new(Marshal.load(fetch_report))
        end

        def merge(other)
          f1, f2 = data[:frames], other.data[:frames]

          frames = (f1.keys + f2.keys).uniq.each_with_object({}) do |id, hash|
            if f1[id].nil?
              hash[id] = f2[id]
            elsif f2[id]
              hash[id] = f1[id]
              hash[id][:total_samples] += f2[id][:total_samples]
              hash[id][:samples] += f2[id][:samples]
              if f2[id][:edges]
                edges = hash[id][:edges] ||= {}
                f2[id][:edges].each do |edge, weight|
                  edges[edge] ||= 0
                  edges[edge] += weight
                end
              end
              if f2[id][:lines]
                lines = hash[id][:lines] ||= {}
                f2[id][:lines].each do |line, weight|
                  lines[line] = add_lines(lines[line], weight)
                end
              end
            else
              hash[id] = f1[id]
            end
            hash
          end

          d1, d2 = data, other.data
          data = {
            version: version,
            mode: d1[:mode],
            interval: d1[:interval],
            samples: d1[:samples] + d2[:samples],
            gc_samples: d1[:gc_samples] + d2[:gc_samples],
            missed_samples: d1[:missed_samples] + d2[:missed_samples],
            metadata: d1[:metadata].merge(d2[:metadata]),
            frames: frames,
            raw: d1[:raw] + d2[:raw],
            raw_timestamp_deltas: d1[:raw_timestamp_deltas] + d2[:raw_timestamp_deltas]
          }

          self.class.new(data)
        end
      end
    end
  end
end
