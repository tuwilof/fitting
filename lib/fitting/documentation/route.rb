require 'fitting/documentation/request/route'
require 'fitting/documentation/responses'

module Fitting
  module Documentation
    class Route
      def initialize(routes, monochrome_route)
        @request = Fitting::Documentation::Request::Route.new(monochrome_route)
        @responses = Fitting::Documentation::Responses.new(routes, monochrome_route)
      end

      def request
        @request
      end

      def responses
        @responses
      end
    end
  end
end
