require 'fitting/documentation/response/routes'

module Fitting
  class Statistics
    class ResponseRoute
      def initialize(responses_all, response_routes)
        @white = Fitting::Documentation::Response::Route.new(responses_all, response_routes.white)
        @black = Fitting::Documentation::Response::Route.new(responses_all, response_routes.black)
      end

      def white
        @white
      end

      def black
        @black
      end
    end
  end
end
