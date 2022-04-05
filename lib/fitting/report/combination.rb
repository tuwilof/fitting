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

      attr_reader :json_schema, :id, :type, :tests

      def mark!(test)
        @tests.push(test)
      end

      def name
        @combination
      end

      def add_test(test)
        @tests.push(test)
      end
    end
  end
end
