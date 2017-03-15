require 'fitting/documentation/request/route/conformity_lists'
require 'fitting/documentation/statistics'

module Fitting
  module Documentation
    class StatisticsWithConformityLists
      def initialize(route)
        @route = route
      end

      def to_s
        conformity_lists = Fitting::Documentation::Request::Route::ConformityLists.new(@route.request).to_s
        statistics = Fitting::Documentation::Statistics.new(@route).to_s

        [conformity_lists, statistics].join("\n\n")
      end
    end
  end
end
