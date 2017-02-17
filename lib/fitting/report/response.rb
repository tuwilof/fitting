require 'fitting/storage/trying_tests'

module Fitting
  module Report
    class Response
      def initialize(tests)
        @json = {
          'convert_responses' => responses_performed_in_tests(tests),
          'have documentation' => responses_performed_in_tests_and_documentation(tests),
          'convert_routes' => route_responses_in_documentation_and_performed_test(tests),
          'valid' => valid(tests),
          'route_responses_in_documentation' => route_responses_in_documentation
        }
        num_tests_without_auto_check_responses = (Fitting::Storage::Tests.all - Fitting::Storage::TryingTests.all).size
        puts "number tests without auto check responses: #{num_tests_without_auto_check_responses}"

        not_documentated_responses = responses_performed_in_tests(tests).size - responses_performed_in_tests_and_documentation(tests).size
        puts "not documentated responses: #{not_documentated_responses}"

        not_cover_routes = route_responses_in_documentation.size - route_responses_in_documentation_and_performed_test(tests).size
        puts "not cover routes: #{not_cover_routes}"

        invalid_routes = route_responses_in_documentation_and_performed_test(tests).size - valid(tests).size
        puts "invalid routes: #{invalid_routes}"
      end

      def responses_performed_in_tests(tests)
        responses = {}
        tests.map do |test|
          request = test['request']
          response = test['response']
          responses["#{response_key(request_key(request), response)} #{response['body'].sum}"] = nil
        end
        responses
      end

      def responses_performed_in_tests_and_documentation(tests)
        responses = {}
        tests.map do |test|
          request = test['request']
          response = test['response']
          if request['schema'] && response['schemas']
            responses["#{response_key(request_key(request), response)} #{response['body'].sum}"] = nil
          end
        end
        responses
      end

      def route_responses_in_documentation_and_performed_test(tests)
        routes = {}
        tests.map do |test|
          request = test['request']
          response = test['response']
          if request['schema'] && response['schemas']
            routes["#{response_key(request_key(request['schema']), response)} #{find_index(response)}"] = nil
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

      def valid(tests)
        routes = {}
        tests.map do |test|
          request = test['request']
          response = test['response']
          if request['schema'] && response['schemas'] && response['valid']
            routes["#{response_key(request_key(request['schema']), response)} #{find_index(response)}"] = nil
          end
        end
        routes
      end

      def request_key(request_data)
        "#{request_data['method']} #{request_data['path']}"
      end

      def response_key(request_data, response_data)
        "#{request_data} #{response_data['status']}"
      end

      def find_index(response)
        response['schemas'].size.times do |i|
          if response['fully_validates'][i] == []
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
