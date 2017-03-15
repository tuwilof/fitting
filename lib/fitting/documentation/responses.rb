module Fitting
  module Documentation
    class Responses
      def initialize(routes, monochrome_route)
        @routes = routes
        @monochrome_route = monochrome_route
      end

      def statistics
        valid_count = @monochrome_route.coverage.size
        valid_percentage = @monochrome_route.cover_ratio
        total_count = @routes.size
        invalid_count = @monochrome_route.not_coverage.size
        invalid_percentage = (100.0 - @monochrome_route.cover_ratio).round(2)

        [
          "API responses conforming to the blueprint: #{valid_count} (#{valid_percentage}% of #{total_count}).",
          "API responses with validation errors or untested: #{invalid_count} (#{invalid_percentage}% of #{total_count})."
        ].join("\n")
      end
    end
  end
end
