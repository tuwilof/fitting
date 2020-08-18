module Fitting
  module Report
    class Combination
      def initialize(json_schema:, type:, combination:)
        @json_schema = json_schema
        @type = type
        @combination = combination
        @tests = Fitting::Report::Tests.new([])
        @id = SecureRandom.hex
      end

      def json_schema
        @json_schema
      end

      def id
        @id
      end

      def type
        @type
      end

      def name
        @combination
      end

      def tests
        @tests
      end

      def add_test(test)
        @tests.push(test)
      end
    end
  end
end
