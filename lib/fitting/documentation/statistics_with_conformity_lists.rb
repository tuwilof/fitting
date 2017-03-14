require 'fitting/documentation/request/route/conformity_lists'
require 'fitting/documentation/statistics'

module Fitting
  module Documentation
    class StatisticsWithConformityLists
      def initialize(request_route, responses_routes, response_route)
        @request_route = request_route
        @responses_routes = responses_routes
        @response_route = response_route
      end

      def to_s
        conformity_lists = Fitting::Documentation::Request::Route::ConformityLists.new(@request_route).to_s
        statistics = Fitting::Documentation::Statistics.new(@request_route, @responses_routes, @response_route).to_s

        [conformity_lists, statistics].join("\n\n")
      end
    end
  end
end
