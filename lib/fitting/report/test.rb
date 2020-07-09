module Fitting
  module Report
    class Test
      def initialize(test)
        @test = test
        @prefix = false
        @action = false
      end

      def path
        @test['path']
      end

      def method
        @test['method']
      end

      def mark_prefix
        @prefix = true
      end

      def mark_action
        @action = true
      end

      def is_there_a_prefix?
        @prefix
      end

      def is_there_an_actions?
        @action
      end
    end
  end
end
