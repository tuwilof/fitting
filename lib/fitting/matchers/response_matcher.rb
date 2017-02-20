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
          return "response not documented\n"
        end

        unless @response.valid?
          fvs = ""
          @response.fully_validates.map { |fv| fvs += "#{fv}\n" }
          shcs = ""
          @response.schemas.map { |shc| shcs += "#{shc}\n" }
          "response not valid json-schema\n"\
          "got: #{@response.body}\n"\
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
