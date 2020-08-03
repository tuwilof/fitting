module Fitting
  module Report
    class Response
      def initialize(response)
        @response = response
        @tests = Fitting::Report::Tests.new([])
      end

      def status
        @response['status']
      end

      def body
        @response['body']
      end

      def add_test(test)
        @tests.push(test)
      end

      def tests
        @tests
      end
    end
  end
end
