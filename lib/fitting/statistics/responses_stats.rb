module Fitting
  class Statistics
    class ResponsesStats
      def initialize(cover_responses, not_cover_responses, all_responses)
        @cover_responses = cover_responses
        @not_cover_responses = not_cover_responses
        @all_responses = all_responses
      end

      def to_s
        [
          "API responses conforming to the blueprint: #{@cover_responses} (#{percent(@all_responses, @cover_responses)}% of #{@all_responses}).",
          "API responses with validation errors or untested: #{@not_cover_responses} (#{percent(@all_responses, @not_cover_responses)}% of #{@all_responses})."
        ].join("\n")
      end

      def percent(divider, dividend)
        return 0 if divider == 0
        (dividend.to_f / divider.to_f * 100.0).round(2)
      end
    end
  end
end
