require 'multi_json'
require 'fitting/documentation/request/route'
require 'fitting/documentation/request/route/conformity_lists'
require 'fitting/documentation/request/route/statistics'
require 'fitting/documentation/response/route/statistics'

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
          @request_route ||= Fitting::Documentation::Request::Route.new(self)
          conformity_lists = Fitting::Documentation::Request::Route::ConformityLists.new(@request_route).to_s
          "#{conformity_lists}\n#{statistics}"
        end

        def statistics
          @request_route ||= Fitting::Documentation::Request::Route.new(self)

          request_route_statistics = Fitting::Documentation::Request::Route::Statistics.new(@request_route).to_s
          response_route_statistics = Fitting::Documentation::Response::Route::Statistics.new(self, @responses_routes).to_s

          "\n#{request_route_statistics}\n#{response_route_statistics}\n"
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
