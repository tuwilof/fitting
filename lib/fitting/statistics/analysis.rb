require 'fitting/statistics/list'
require 'fitting/statistics/requests_stats'
require 'fitting/statistics/responses_stats'
require 'fitting/statistics/great'
require 'fitting/statistics/measurement'
require 'fitting/statistics/not_covered_responses'

module Fitting
  class Statistics
    class Analysis
      def initialize(requests)
        @measurement = Fitting::Statistics::Measurement.new(requests)
      end

      def all
        [
          Fitting::Statistics::List.new(@measurement).to_s,
          Fitting::Statistics::RequestsStats.new(@measurement).to_s,
          Fitting::Statistics::ResponsesStats.new(@measurement).to_s,
          Fitting::Statistics::Great.new(@measurement).to_s,
        ].compact.join("\n\n")
      end

      def not_covered
        Fitting::Statistics::NotCoveredResponses.new(@measurement).to_s
      end
    end
  end
end
