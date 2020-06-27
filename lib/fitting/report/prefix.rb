module Fitting
  module Report
    class Prefix
      def initialize(name)
        @name = name
        @tests = []
      end

      def name
        @name
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
