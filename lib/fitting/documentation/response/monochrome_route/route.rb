require 'multi_json'
#Fitting::Documentation::Response::
module Fitting
  module Documentation
    class Response
      class MonochromeRoute
        class Route
          def initialize(coverage_responses, responses_routes)
            @coverage_responses = coverage_responses
            @responses_routes = responses_routes
          end

          def coverage
            @coverage ||= @responses_routes - (@responses_routes - full_coverage)
          end

          def not_coverage
            @not_coverage ||= @responses_routes - coverage
          end

          def cover_ratio
            @cover_ratio ||= (coverage.size.to_f / @responses_routes.size.to_f * 100.0).round(2)
          end

          def to_hash
            {
              'coverage' => coverage,
              'not coverage' => not_coverage
            }
          end

          private

          def full_coverage
            @coverage_responses.map do |response|
              response.route if response.documented? && response.valid?
            end.compact.uniq
          end
        end
      end
    end
  end
end
