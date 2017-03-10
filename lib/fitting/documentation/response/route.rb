require 'multi_json'
require 'fitting/documentation/request/route'

module Fitting
  module Documentation
    module Response
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

        def statistics_with_conformity_lists
          @request_routes ||= Fitting::Documentation::Request::Route.new(self)
          @request_routes.conformity_lists
          statistics
        end

        def statistics
          @request_routes ||= Fitting::Documentation::Request::Route.new(self)
          @request_routes.statistics

          valid_count = coverage.size
          valid_percentage = cover_ratio
          total_count = @responses_routes.size
          invalid_count = not_coverage.size
          invalid_percentage = 100.0 - cover_ratio
          puts "API responses conforming to the blueprint: #{valid_count} (#{valid_percentage}% of #{total_count})."
          puts "API responses with validation errors or untested: #{invalid_count} (#{invalid_percentage}% of #{total_count})."
          puts
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
