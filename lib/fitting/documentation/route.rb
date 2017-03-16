require 'fitting/documentation/response/monochrome_route/route'
require 'fitting/documentation/request/route'
require 'fitting/documentation/responses'

module Fitting
  module Documentation
    class Route
      def initialize(all_responses, routes)
        monochrome_route = Fitting::Documentation::Response::MonochromeRoute::Route.new(all_responses, routes)
        @request = Fitting::Documentation::Request::Route.new(monochrome_route)
        @responses = Fitting::Documentation::Responses.new(routes, monochrome_route)
      end

      def statistics
        [@request.statistics, @responses.statistics].join("\n\n")
      end

      def statistics_with_conformity_lists
        [@request.conformity_lists, statistics].join("\n\n")
      end
    end
  end
end
