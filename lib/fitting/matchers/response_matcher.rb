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
        @response.fully_validates.valid?
      end

      def ===(other)
        matches?(other)
      end

      def failure_message
        unless @response.documented?
          return "response not documented\n"\
                 "got: #{@response.real_request_with_status}"
        end

        unless @response.fully_validates.valid?
          "response does not conform to json-schema\n"\
          "schemas: \n#{@response.expected}\n\n"\
          "got: #{@response.got}\n\n"\
          "errors: \n#{@response.fully_validates}\n"
        end
      end
    end

    class StrictResponse
      def matches?(response)
        @response = Fitting::Response.new(
          response,
          Fitting::Storage::Documentation.tomogram
        )
        @response.strict_fully_validates.valid?
      end

      def ===(other)
        matches?(other)
      end

      def failure_message
        unless @response.documented?
          return "response not documented\n"\
                 "got: #{@response.real_request_with_status}"
        end

        unless @response.strict_fully_validates.valid?
          "response does not conform to json-schema\n"\
          "schemas: \n#{@response.expected}\n\n"\
          "got: #{@response.got}\n\n"\
          "errors: \n#{@response.strict_fully_validates}\n"
        end
      end
    end

    def match_schema
      Response.new
    end

    def strictly_match_schema
      StrictResponse.new
    end
  end
end
