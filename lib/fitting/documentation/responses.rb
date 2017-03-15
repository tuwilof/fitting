module Fitting
  module Documentation
    class Responses
      def initialize(routes, monochrome_route)
        @routes = routes
        @monochrome_route = monochrome_route
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
