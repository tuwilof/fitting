require 'fitting/documentation/response/route'
require 'fitting/documentation/requests'
require 'fitting/documentation/responses'

module Fitting
  class Documentation
    class Route
      def initialize(all_responses, routes)
        monochrome_route = Fitting::Documentation::Response::Route.new(all_responses, routes)
        @requests = Fitting::Documentation::Requests.new(monochrome_route)
        @responses = Fitting::Documentation::Responses.new(routes, monochrome_route)
      end

      def statistics
        [@requests.statistics, @responses.statistics].join("\n\n")
      end

      def statistics_with_conformity_lists
        [@requests.conformity_lists, statistics].join("\n\n")
      end
    end
  end
end
