module Fitting
  class Statistics
    class Great
      def initialize(measurement)
        @measurement = measurement
      end

      def to_s
        if @measurement.cover_responses == @measurement.all_responses
          'All responses are 100% valid! Great job!'
        end
      end
    end
  end
end
