require 'fitting/statistics/percent'

module Fitting
  class Statistics
    class ResponsesStats
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        @to_s ||= [
          "API responses conforming to the blueprint: #{cover}.",
          "API responses with validation errors or untested: #{not_cover}."
        ].join("\n")
      end

      def cover
        @cover ||= Fitting::Statistics::Percent.new(
          @measurement.all_responses,
          @measurement.cover_responses
        )
      end

      def not_cover
        @not_cover ||= Fitting::Statistics::Percent.new(
          @measurement.all_responses,
          @measurement.not_cover_responses
        )
      end
    end
  end
end
