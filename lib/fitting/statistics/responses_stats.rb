require 'fitting/statistics/percent'

module Fitting
  class Statistics
    class ResponsesStats
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          "API responses conforming to the blueprint: #{@measurement.cover_responses} (#{Fitting::Statistics::Percent.new(@measurement.all_responses, @measurement.cover_responses).to_s}% of #{@measurement.all_responses}).",
          "API responses with validation errors or untested: #{@measurement.not_cover_responses} (#{Fitting::Statistics::Percent.new(@measurement.all_responses, @measurement.not_cover_responses).to_s}% of #{@measurement.all_responses})."
        ].join("\n")
      end
    end
  end
end
