module Fitting
  class Statistics
    class Great
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        return 'All responses are 100% valid! Great job!' if @measurement.cover_responses == @measurement.all_responses
      end
    end
  end
end
