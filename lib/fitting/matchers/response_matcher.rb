require 'fitting/storage/trying_tests'

module Fitting
  module Matchers
    class Response
      def matches?(response)
        @request, @response = Fitting::Documentation.try_on(response)
        Fitting::Storage::TryingTests.push(
          {
            'request' => @request,
            'response' => @response
          }
        )
        @response["valid"] == true
      end

      def ===(other)
        matches?(other)
      end

      def failure_message
        if @response["valid"].nil?
          "response not documented\n"
        else
          fvs = ""
          @response["fully_validates"].map { |fv| fvs += "#{fv}\n" }
          shcs = ""
          @response["schemas"].map { |shc| shcs += "#{shc}\n" }
          "response not valid json-schema\n"\
        "got: #{@response["body"]}\n"\
        "diff: \n#{fvs}"\
        "expected: \n#{shcs}\n"
        end
      end
    end

    def match_response
      Response.new
    end
  end
end
