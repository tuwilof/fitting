module Fitting
  class Statistics
    class RequestsStats
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          "API requests with fully implemented responses: #{@measurement.coverage_fully.size} (#{percent(@measurement.requests.size, @measurement.coverage_fully.size)}% of #{@measurement.requests.size}).",
          "API requests with partially implemented responses: #{@measurement.coverage_partially.size} (#{percent(@measurement.requests.size, @measurement.coverage_partially.size)}% of #{@measurement.requests.size}).",
          "API requests with no implemented responses: #{@measurement.coverage_non.size} (#{percent(@measurement.requests.size, @measurement.coverage_non.size)}% of #{@measurement.requests.size})."
        ].join("\n")
      end

      def percent(divider, dividend)
        return 0 if divider == 0
        (dividend.to_f / divider.to_f * 100.0).round(2)
      end
    end
  end
end
