require 'fitting/documentation/request/route/statistics'
require 'fitting/documentation/response/monochrome_route/route/statistics'

module Fitting
  module Documentation
    class Statistics
      def initialize(route)
        @request_route = route.request
        @responses = route.responses
      end

      def to_s
        request_route_statistics = Fitting::Documentation::Request::Route::Statistics.new(@request_route).to_s
        response_route_statistics = Fitting::Documentation::Response::MonochromeRoute::Route::Statistics.new(@responses).to_s

        [request_route_statistics, response_route_statistics].join("\n\n")
      end
    end
  end
end
