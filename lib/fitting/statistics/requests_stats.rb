module Fitting
  class Statistics
    class RequestsStats
      def initialize(measurement)
        @coverage_fully = measurement.coverage_fully
        @coverage_partially = measurement.coverage_partially
        @coverage_non = measurement.coverage_non
        @requests = measurement.requests
      end

      def to_s
        [
          "API requests with fully implemented responses: #{@coverage_fully.size} (#{percent(@requests.size, @coverage_fully.size)}% of #{@requests.size}).",
          "API requests with partially implemented responses: #{@coverage_partially.size} (#{percent(@requests.size, @coverage_partially.size)}% of #{@requests.size}).",
          "API requests with no implemented responses: #{@coverage_non.size} (#{percent(@requests.size, @coverage_non.size)}% of #{@requests.size})."
        ].join("\n")
      end

      def percent(divider, dividend)
        return 0 if divider == 0
        (dividend.to_f / divider.to_f * 100.0).round(2)
      end
    end
  end
end
