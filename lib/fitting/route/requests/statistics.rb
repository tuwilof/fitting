module Fitting
  class Route
    class Requests
      class Statistics
        def initialize(stat)
          @stat = stat
        end

        def to_s
          [
            "API requests with fully implemented responses: #{full_count} (#{full_percentage}% of #{total_count}).",
            "API requests with partially implemented responses: #{part_count} (#{part_percentage}% of #{total_count}).",
            "API requests with no implemented responses: #{no_count} (#{no_percentage}% of #{total_count})."
          ].join("\n")
        end

        def full_count
          @full_count ||= @stat.to_hash['full cover'].size
        end

        def part_count
          @part_count ||= @stat.to_hash['partial cover'].size
        end

        def no_count
          @no_count ||= @stat.to_hash['no cover'].size
        end

        def total_count
          @total_count ||= full_count + part_count + no_count
        end

        def full_percentage
          @full_percentage ||= (full_count.to_f / total_count.to_f * 100.0).round(2)
        end

        def part_percentage
          @part_percentage ||= (part_count.to_f / total_count.to_f * 100.0).round(2)
        end

        def no_percentage
          @no_percentage ||= (no_count.to_f / total_count.to_f * 100.0).round(2)
        end
      end
    end
  end
end
