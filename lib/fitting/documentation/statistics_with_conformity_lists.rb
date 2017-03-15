require 'fitting/documentation/statistics'

module Fitting
  module Documentation
    class StatisticsWithConformityLists
      def initialize(route)
        @conformity_lists = route.request.conformity_lists
        @statistics = Fitting::Documentation::Statistics.new(route)
      end

      def to_s
        [@conformity_lists, @statistics].join("\n\n")
      end
    end
  end
end
