require 'fitting/storage/trying_tests'

module Fitting
  module Report
    class Response
      def initialize(responses)
        coverage = coverage_routes(responses)
        @json = {
          'coverage' => coverage,
          'not coverage' => Fitting::Documentation.routes - coverage
        }
        puts "Coverage documentations API by RSpec tests: #{percent_covered(responses)}%"
      end

      def percent_covered(tests)
        covered = coverage_routes(tests).size.to_f
        all = Fitting::Documentation.routes.size.to_f
        (covered / all * 100.0).round(2)
      end

      def coverage_routes(responses)
        routes = {}
        responses.map do |response|
          if response.documented? && response.valid?
            routes[response.route] = nil
          end
        end
        routes.keys
      end

      def to_hash
        @json
      end
    end
  end
end
