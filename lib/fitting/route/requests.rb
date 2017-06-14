require 'multi_json'
require 'fitting/route/requests/statistics'
require 'fitting/route/requests/lists'
require 'fitting/route/requests/coverage'
require 'fitting/route/requests/combine'

module Fitting
  class Route
    class Requests
      def initialize(coverage)
        @combine = Fitting::Route::Requests::Combine.new(Fitting::Route::Requests::Coverage.new(coverage))
        @lists = Fitting::Route::Requests::Lists.new(@combine)
        @statistics = Fitting::Route::Requests::Statistics.new(@combine)
      end

      def conformity_lists
        @lists.to_s
      end

      def statistics
        @statistics.to_s
      end
    end
  end
end
