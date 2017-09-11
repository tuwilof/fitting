require 'fitting/statistics/percent'

module Fitting
  class Statistics
    class RequestsStats
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          "API requests with fully implemented responses: #{Fitting::Statistics::Percent.new(@measurement.requests.size, @measurement.coverage_fully.size).to_s}.",
          "API requests with partially implemented responses: #{Fitting::Statistics::Percent.new(@measurement.requests.size, @measurement.coverage_partially.size).to_s}.",
          "API requests with no implemented responses: #{Fitting::Statistics::Percent.new(@measurement.requests.size, @measurement.coverage_non.size).to_s}."
        ].join("\n")
      end
    end
  end
end
