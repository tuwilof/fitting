module Fitting
  class Statistics
    class ResponsesStats
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          "API responses conforming to the blueprint: #{@measurement.cover_responses} (#{percent(@measurement.all_responses, @measurement.cover_responses)}% of #{@measurement.all_responses}).",
          "API responses with validation errors or untested: #{@measurement.not_cover_responses} (#{percent(@measurement.all_responses, @measurement.not_cover_responses)}% of #{@measurement.all_responses})."
        ].join("\n")
      end

      def percent(divider, dividend)
        return 0 if divider == 0
        (dividend.to_f / divider.to_f * 100.0).round(2)
      end
    end
  end
end
