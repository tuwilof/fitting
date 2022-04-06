require 'fitting/report/response'

module Fitting
  module Report
    class Responses
      def initialize(responses)
        @responses = responses
        @responses = []
        responses.to_a.map do |response|
          @responses.push(Fitting::Report::Response.new(response))
        end
      end

      def find!(test)
        @responses.map do |response|
          if response.status.to_s == test.status && JSON::Validator.fully_validate(response.body, test.body) == []
            return response
          end
        end
      end

      def to_a
        @responses
      end
    end
  end
end
