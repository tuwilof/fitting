require 'fitting/response'
require 'fitting/storage/documentation'

module Fitting
  module Matchers
    class Response
      def matches?(response)
        @response = Fitting::Response.new(
          response,
          Fitting::Storage::Documentation.tomogram
        )
        @response.fully_validates.any? { |fully_validate| fully_validate == [] }
      end

      def ===(other)
        matches?(other)
      end

      def failure_message
        unless @response.documented?
          return "response not documented\n"\
                 "got: #{@response.real_request_with_status}"
        end

        unless @response.fully_validates.any? { |fully_validate| fully_validate == [] }
          "response does not conform to json-schema\n"\
          "schemas: \n#{@response.expected}\n\n"\
          "got: #{@response.got}\n\n"\
          "errors: \n#{@response.diff}\n"
        end
      end
    end

    def match_response
      Response.new
    end
  end
end
