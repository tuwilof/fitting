module Fitting
  class Route
    class Responses
      def initialize(routes, coverage)
        @routes = routes
        @coverage = coverage
      end

      def statistics
        valid_count = @coverage.coverage.size
        valid_percentage = @coverage.cover_ratio
        total_count = @routes.size
        invalid_count = @coverage.not_coverage.size
        invalid_percentage = (100.0 - @coverage.cover_ratio).round(2)

        [
          "API responses conforming to the blueprint: #{valid_count} (#{valid_percentage}% of #{total_count}).",
          "API responses with validation errors or untested: #{invalid_count} (#{invalid_percentage}% of #{total_count})."
        ].join("\n")
      end
    end
  end
end
