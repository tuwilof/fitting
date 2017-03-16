require 'fitting/documentation/coverage'
require 'fitting/documentation/requests'
require 'fitting/documentation/responses'

module Fitting
  class Documentation
    class Route
      def initialize(all_responses, routes)
        coverage = Fitting::Documentation::Coverage.new(all_responses, routes)
        @requests = Fitting::Documentation::Requests.new(coverage)
        @responses = Fitting::Documentation::Responses.new(routes, coverage)
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
