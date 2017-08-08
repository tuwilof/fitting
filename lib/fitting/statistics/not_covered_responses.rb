module Fitting
  class Statistics
    class NotCoveredResponses
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        @measurement.not_covered_responses.join("\n") + "\n"
      end
    end
  end
end
