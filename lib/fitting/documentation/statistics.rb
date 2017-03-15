module Fitting
  module Documentation
    class Statistics
      def initialize(route)
        @request_route_statistics = route.request.statistics
        @response_route_statistics = route.responses.statistics
      end

      def to_s
        [@request_route_statistics, @response_route_statistics].join("\n\n")
      end
    end
  end
end
