require 'fitting/documentation/request/route/conformity_lists'
require 'fitting/documentation/statistics'

module Fitting
  module Documentation
    class StatisticsWithConformityLists
      def initialize(request_route, responses)
        @request_route = request_route
        @responses = responses
      end

      def to_s
        conformity_lists = Fitting::Documentation::Request::Route::ConformityLists.new(@request_route).to_s
        statistics = Fitting::Documentation::Statistics.new(@request_route, @responses).to_s

        [conformity_lists, statistics].join("\n\n")
      end
    end
  end
end
