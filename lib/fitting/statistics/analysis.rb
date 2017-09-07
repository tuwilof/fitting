require 'fitting/statistics/list'
require 'fitting/statistics/requests_stats'
require 'fitting/statistics/responses_stats'
require 'fitting/statistics/great'
require 'fitting/statistics/not_covered_responses'

module Fitting
  class Statistics
    class Analysis
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        [
          Fitting::Statistics::List.new(@measurement).to_s,
          Fitting::Statistics::RequestsStats.new(@measurement).to_s,
          Fitting::Statistics::ResponsesStats.new(@measurement).to_s,
          Fitting::Statistics::Great.new(@measurement).to_s
        ].compact.join("\n\n")
      end
    end
  end
end
