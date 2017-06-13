module Fitting
  class Route
    class Requests
      class Statistics
        def initialize(full_count, part_count, no_count)
          @full_count = full_count
          @part_count = part_count
          @no_count = no_count
        end

        def to_s
          @to_s ||= [
            "API requests with fully implemented responses: #{@full_count} (#{full_percent}% of #{total_count}).",
            "API requests with partially implemented responses: #{@part_count} (#{part_percent}% of #{total_count}).",
            "API requests with no implemented responses: #{@no_count} (#{no_percent}% of #{total_count})."
          ].join("\n")
        end

        def total_count
          @total_count ||= @full_count + @part_count + @no_count
        end

        def full_percent
          @full_percentage ||= 0.0 if total_count.zero?
          @full_percentage ||= (@full_count.to_f / total_count.to_f * 100.0).round(2)
        end

        def part_percent
          @part_percentage ||= 0.0 if total_count.zero?
          @part_percentage ||= (@part_count.to_f / total_count.to_f * 100.0).round(2)
        end

        def no_percent
          @no_percentage ||= 0.0 if total_count.zero?
          @no_percentage ||= (@no_count.to_f / total_count.to_f * 100.0).round(2)
        end
      end
    end
  end
end
