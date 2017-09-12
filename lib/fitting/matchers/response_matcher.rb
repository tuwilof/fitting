require 'fitting/response'
require 'fitting/configuration'

module Fitting
  module Matchers
    class Response
      def matches?(response)
        if Fitting.configuration.is_a?(Array)
          Fitting.configuration.all? do |config|
            response = Fitting::Response.new(
              response,
              config.tomogram
            )
            if response.within_prefix?(config.prefix)
              @response = response
              return true if @response.ignored?(config.ignore_list)
              return @response.fully_validates.valid?
            else
              true
            end
          end
        else
          @response = Fitting::Response.new(
            response,
            Fitting.configuration.tomogram
          )
          return true if @response.ignored?(Fitting.configuration.ignore_list)
          if @response.within_prefix?(Fitting.configuration.prefix)
            @response.fully_validates.valid?
          else
            true
          end
        end
      end

      def ===(other)
        matches?(other)
      end

      def failure_message
        unless @response.documented?
          return "response not documented\n"\
                 "got: #{@response.real_request_with_status}"
        end

        return nil if @response.fully_validates.valid?

        "response does not conform to json-schema\n"\
          "schemas: \n#{@response.expected}\n\n"\
          "got: #{@response.got}\n\n"\
          "errors: \n#{@response.fully_validates}\n"
      end
    end

    class StrictResponse
      def matches?(response)
        @response = Fitting::Response.new(
          response,
          Fitting.configuration.tomogram
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

        return nil if @response.strict_fully_validates.valid?

        "response does not conform to json-schema\n"\
          "schemas: \n#{@response.expected}\n\n"\
          "got: #{@response.got}\n\n"\
          "errors: \n#{@response.strict_fully_validates}\n"
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
