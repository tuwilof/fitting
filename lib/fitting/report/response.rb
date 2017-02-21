require 'fitting/storage/trying_tests'

module Fitting
  module Report
    class Response
      def initialize
        all = Fitting::Documentation.routes
        coverage = Fitting::Storage::TryingTests.routes
        @json = {
          'coverage' => coverage,
          'not coverage' => all - coverage
        }
        puts "Coverage documentations API by RSpec tests: #{percent_covered(all, coverage)}%"
      end

      def percent_covered(all, coverage)
        (coverage.size.to_f / all.size.to_f * 100.0).round(2)
      end

      def to_hash
        @json
      end
    end
  end
end
