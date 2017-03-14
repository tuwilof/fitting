module Fitting
  module Documentation
    module Response
      class Route
        class Statistics
          def initialize(response_routes, responses_routes)
            @response_routes = response_routes
            @responses_routes = responses_routes
          end

          def to_s
            valid_count = @response_routes.coverage.size
            valid_percentage = @response_routes.cover_ratio
            total_count = @responses_routes.size
            invalid_count = @response_routes.not_coverage.size
            invalid_percentage = 100.0 - @response_routes.cover_ratio

            [
              "API responses conforming to the blueprint: #{valid_count} (#{valid_percentage}% of #{total_count}).",
              "API responses with validation errors or untested: #{invalid_count} (#{invalid_percentage}% of #{total_count})."
            ].join("\n")
          end
        end
      end
    end
  end
end
