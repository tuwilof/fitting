require 'fitting/report/responses'

module Fitting
  module Report
    class Action
      def initialize(action)
        @action = action
        @tests = Fitting::Report::Tests.new([])
        @responses = Fitting::Report::Responses.new(@action.responses)
      end

      def method
        @action.method
      end

      def path
        @action.path.to_s
      end

      def responses
        @responses
      end

      def add_test(test)
        @tests.push(test)
      end

      def path_match(find_path)
        regexp =~ find_path
      end

      def regexp
        return @regexp if @regexp

        str = Regexp.escape(path)
        str = str.gsub(/\\{\w+\\}/, '[^&=\/]+')
        str = "\\A#{str}\\z"
        @regexp = Regexp.new(str)
      end

      def tests
        @tests
      end

      def details
        {
            tests_without_responses: @tests.without_responses,
            responses_details: @responses.to_a.map { |r| {method: r.status, tests_size: r.tests.size} }
        }
      end
    end
  end
end
