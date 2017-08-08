module Fitting
  class Statistics
    class Great
      def initialize(cover_responses, all_responses)
        @cover_responses = cover_responses
        @all_responses = all_responses
      end

      def to_s
        if @cover_responses == @all_responses
          'All responses are 100% valid! Great job!'
        else
          nil
        end
      end
    end
  end
end
