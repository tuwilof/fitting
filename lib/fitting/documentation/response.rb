require 'fitting/documentation/response/routes'
require 'fitting/documentation/response/monochrome_route'

module Fitting
  module Documentation
    class Response
      def initialize(documentation, white_list, all_responses)
        @routes = Fitting::Documentation::Response::Routes.new(documentation, white_list)
        @monochrome_route = Fitting::Documentation::Response::MonochromeRoute.new(all_responses, @routes)
      end

      def routes
        @routes
      end

      def monochrome_route
        @monochrome_route
      end
    end
  end
end
