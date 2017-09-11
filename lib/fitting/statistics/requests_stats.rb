require 'fitting/statistics/percent'

module Fitting
  class Statistics
    class RequestsStats
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          "API requests with fully implemented responses: #{@measurement.coverage_fully.size} (#{Fitting::Statistics::Percent.new(@measurement.requests.size, @measurement.coverage_fully.size).to_f}% of #{@measurement.requests.size}).",
          "API requests with partially implemented responses: #{@measurement.coverage_partially.size} (#{Fitting::Statistics::Percent.new(@measurement.requests.size, @measurement.coverage_partially.size).to_f}% of #{@measurement.requests.size}).",
          "API requests with no implemented responses: #{@measurement.coverage_non.size} (#{Fitting::Statistics::Percent.new(@measurement.requests.size, @measurement.coverage_non.size).to_f}% of #{@measurement.requests.size})."
        ].join("\n")
      end
    end
  end
end
