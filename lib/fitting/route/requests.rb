require 'multi_json'
require 'fitting/route/requests/statistics'
require 'fitting/route/requests/lists'
require 'fitting/route/requests/coverage'
require 'fitting/route/requests/combine'

module Fitting
  class Route
    class Requests
      def initialize(coverage)
        @coverage = coverage
      end

      def to_hash
        @stat ||= coverage_statistic
      end

      def conformity_lists
        @stat ||= coverage_statistic
        Fitting::Route::Requests::Lists.new(
          @combine.full_cover,
          @combine.partial_cover,
          @combine.no_cover,
          @combine.max
        ).to_s
      end

      def statistics
        @stat ||= coverage_statistic
        Fitting::Route::Requests::Statistics.new(
          @combine.full_cover.size,
          @combine.partial_cover.size,
          @combine.no_cover.size
        ).to_s
      end

      private

      def coverage_statistic
        coverage = Fitting::Route::Requests::Coverage.new(@coverage)
        @combine = Fitting::Route::Requests::Combine.new(coverage.to_hash)
        @combine.to_hash
      end
    end
  end
end
