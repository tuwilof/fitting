module Fitting
  class Statistics
    class Great
      def initialize(measurement)
        @cover_responses = measurement.cover_responses
        @all_responses = measurement.all_responses
      end

      def to_s
        if @cover_responses == @all_responses
          'All responses are 100% valid! Great job!'
        end
      end
    end
  end
end
