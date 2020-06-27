module Fitting
  module Report
    class Test
      def initialize(test)
        @test = test
        @prefix = false
      end

      def path
        @test['path']
      end

      def mark_prefix
        @prefix = true
      end

      def is_there_a_prefix?
        @prefix
      end
    end
  end
end
