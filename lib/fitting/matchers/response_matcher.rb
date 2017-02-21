require 'fitting/storage/trying_tests'
require 'fitting/response'

module Fitting
  module Matchers
    class Response
      def matches?(response)
        @response = Fitting::Response.new(response, Fitting::Documentation.tomogram)
        Fitting::Storage::TryingTests.push(@response)
        @response.valid?
      end

      def ===(other)
        matches?(other)
      end

      def failure_message
        unless @response.documented?
          return "response not documented\n"\
                 "got: #{@response.real}"
        end

        unless @response.valid?
          "response not valid json-schema\n"\
          "got: #{@response.got}\n"\
          "diff: \n#{@response.diff}"\
          "expected: \n#{@response.expected}\n"
        end
      end
    end

    def match_response
      Response.new
    end
  end
end
