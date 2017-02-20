require 'fitting/storage/trying_tests'

module Fitting
  module Report
    class Response
      def initialize(responses)
        coverage = coverage_routes(responses)
        @json = {
          'coverage' => coverage,
          'not coverage' => route_responses_in_documentation.keys - coverage
        }
        puts "Coverage documentations API by RSpec tests: #{percent_covered(responses)}%"
      end

      def percent_covered(tests)
        covered = route_responses_in_documentation_and_performed_test(tests).size.to_f
        all = route_responses_in_documentation.size.to_f
        (covered / all * 100.0).round(2)
      end

      def route_responses_in_documentation_and_performed_test(tests)
        routes = {}
        tests.map do |response|
          request = response.request
          if response.documented?
            routes["#{response_key(request_key(request.schema['method'], request.schema['path']), response.status)} #{find_index(response)}"] = nil
          end
        end
        routes
      end

      def route_responses_in_documentation
        full_responses = {}
        MultiJson.load(Fitting.configuration.tomogram).map do |request|
          responses = {}
          request['responses'].map do |response|
            unless responses[response['status']]
              responses[response['status']] = 0
            end
            responses[response['status']] += 1
          end

          responses.map do |response|
            response.last.times do |index|
              full_responses["#{request['method']} #{request['path']} #{response.first} #{index}"] = nil
            end
          end
        end
        full_responses
      end

      def coverage_routes(responses)
        routes = {}
        responses.map do |response|
          if response.documented? && response.valid?
            key_request = request_key(response.request.schema['method'], response.request.schema['path'])
            key_response = response_key(key_request, response.status)
            routes["#{key_response} #{find_index(response)}"] = nil
          end
        end
        routes.keys
      end

      def request_key(request_method, request_path)
        "#{request_method} #{request_path}"
      end

      def response_key(key_request, response_status)
        "#{key_request} #{response_status}"
      end

      def find_index(response)
        response.schemas.size.times do |i|
          if response.fully_validates[i] == []
            return i
          end
        end
      end

      def to_hash
        @json
      end
    end
  end
end
