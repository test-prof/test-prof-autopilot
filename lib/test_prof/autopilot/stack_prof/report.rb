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
          ids_mapping = generate_ids_mapping(data[:frames], other.data[:frames])

          frames = data[:frames].dup

          other.data[:frames].each do |id, new_frame|
            frame =
              if ids_mapping[id]
                frames[ids_mapping[id]]
              else
                frames[id] = empty_frame_from(new_frame)
              end

            frame[:total_samples] += new_frame[:total_samples]
            frame[:samples] += new_frame[:samples]

            if new_frame[:edges]
              edges = (frame[:edges] ||= {})

              new_frame[:edges].each do |edge, weight|
                old_edge = ids_mapping[edge]

                if edges[old_edge]
                  edges[old_edge] += weight
                else
                  edges[old_edge] = weight
                end
              end
            end

            if new_frame[:lines]
              lines = (frame[:lines] ||= {})

              new_frame[:lines].each do |line, weight|
                old_line = ids_mapping[line]

                lines[old_line] =
                  if lines[old_line]
                    add_lines(lines[old_line], weight)
                  else
                    weight
                  end
              end
            end
          end

          converted_raw = other.data[:raw].map do |raw|
            ids_mapping[raw] || raw
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
            raw: d1[:raw] + converted_raw,
            raw_timestamp_deltas: d1[:raw_timestamp_deltas] + d2[:raw_timestamp_deltas]
          }

          self.class.new(data)
        end

        def generate_ids_mapping(frames, other_frames)
          old_fingerprints = frames_to_fingerprints(frames)
          new_fingerprints = frames_to_fingerprints(other_frames)

          new_fingerprints.each_with_object({}) do |(fingerprint, frame), hash|
            next hash unless old_fingerprints[fingerprint]

            hash[frame[:id]] = old_fingerprints[fingerprint][:id]
          end
        end

        def frames_to_fingerprints(frames)
          frames.each_with_object({}) do |(id, frame), hash|
            fingerprint = [frame[:name], frame[:file], frame[:line]].compact.map(&:to_s).join("/")
            hash[fingerprint] = frame.merge(id: id)
            hash
          end
        end

        def empty_frame_from(frame)
          frame.slice(:name, :file, :line).merge(
            total_samples: 0,
            samples: 0
          )
        end
      end
    end
  end
end
