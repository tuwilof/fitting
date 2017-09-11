require 'fitting/statistics/percent'

module Fitting
  class Statistics
    class RequestsStats
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        @to_s ||= [
          "API requests with fully implemented responses: #{fully}.",
          "API requests with partially implemented responses: #{partially}.",
          "API requests with no implemented responses: #{non}."
        ].join("\n")
      end

      def fully
        @fully ||= Fitting::Statistics::Percent.new(
          @measurement.requests.size,
          @measurement.coverage_fully.size
        )
      end

      def partially
        @partially ||= Fitting::Statistics::Percent.new(
          @measurement.requests.size,
          @measurement.coverage_partially.size
        )
      end

      def non
        @non ||= Fitting::Statistics::Percent.new(
          @measurement.requests.size,
          @measurement.coverage_non.size
        )
      end
    end
  end
end
