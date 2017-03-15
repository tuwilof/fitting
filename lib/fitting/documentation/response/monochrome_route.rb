require 'fitting/documentation/response/monochrome_route/route'

module Fitting
  module Documentation
    class Response
      class MonochromeRoute
        def initialize(responses_all, response_routes)
          @white = Fitting::Documentation::Response::MonochromeRoute::Route.new(responses_all, response_routes.white)
          @black = Fitting::Documentation::Response::MonochromeRoute::Route.new(responses_all, response_routes.black)
        end

        def white_not_coverage?
          @white.not_coverage.present?
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
end
