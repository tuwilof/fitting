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

      def join(tests)
        tests.to_a.map do |test|
          if there_a_suitable_response?(test)
            cram_into_the_appropriate_response(test)
            test.mark_response
          end
        end
      end

      def there_a_suitable_response?(test)
        return false if @responses.nil?

        @responses.map do |response|
          return true if response.status.to_s == test.status &&
                         JSON::Validator.fully_validate(response.body, test.body) == []
        end

        false
      end

      def cram_into_the_appropriate_response(test)
        @responses.map do |response|
          next unless response.status.to_s == test.status &&
                      JSON::Validator.fully_validate(response.body, test.body) == []

          response.add_test(test)
          break
        end
      end
    end
  end
end
