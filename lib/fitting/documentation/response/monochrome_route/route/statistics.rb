module Fitting
  module Documentation
    class Response
      class MonochromeRoute
        class Route
          class Statistics
            def initialize(responses)
              @response_routes = responses.monochrome_route
              @responses_routes = responses.routes
            end

            def to_s
              valid_count = @response_routes.coverage.size
              valid_percentage = @response_routes.cover_ratio
              total_count = @responses_routes.size
              invalid_count = @response_routes.not_coverage.size
              invalid_percentage = (100.0 - @response_routes.cover_ratio).round(2)

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
end
