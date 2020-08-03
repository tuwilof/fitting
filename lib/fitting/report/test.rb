module Fitting
  module Report
    class Test
      def initialize(test)
        @test = test
        @prefix = false
        @action = false
        @response = false
      end

      def path
        @test['path']
      end

      def method
        @test['method']
      end

      def status
        @test['response']['status'].to_s
      end

      def body
        @test['response']['body']
      end

      def mark_prefix
        @prefix = true
      end

      def mark_action
        @action = true
      end

      def mark_response
        @response = true
      end

      def is_there_a_prefix?
        @prefix
      end

      def is_there_an_actions?
        @action
      end

      def is_there_an_responses?
        @action
      end
    end
  end
end
