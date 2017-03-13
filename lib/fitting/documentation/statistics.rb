require 'fitting/documentation/request/route/statistics'
require 'fitting/documentation/response/route/statistics'

module Fitting
  module Documentation
    class Statistics
      def initialize(request_route, responses_routes, response_route)
        @request_route = request_route
        @responses_routes = responses_routes
        @response_route = response_route
      end

      def to_s
        request_route_statistics = Fitting::Documentation::Request::Route::Statistics.new(@request_route).to_s
        response_route_statistics = Fitting::Documentation::Response::Route::Statistics.new(@response_route, @responses_routes).to_s

        "\n#{request_route_statistics}\n#{response_route_statistics}\n"
      end
    end
  end
end
