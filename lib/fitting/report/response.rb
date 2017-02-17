module Fitting
  module Report
    class Response
      def initialize(tests)
        @json = {
          'performed_tests_controllers_match_response' => performed_tests_for_controllers_with_match_response(tests),
          'convert_responses' => responses_performed_in_tests(tests),
          'have documentation' => responses_performed_in_tests_and_documentation(tests),
          'convert_routes' => route_responses_in_documentation_and_performed_test(tests),
          'valid' => valid(tests)
        }
      end

      def performed_tests_for_controllers_with_match_response(tests)
        test_with_location = {}
        tests.map do |location, test|
          test_with_location[location] = nil
        end
        test_with_location
      end

      def responses_performed_in_tests(tests)
        responses = {}
        tests.map do |location, test|
          request = MultiJson.load(test['request'])
          response = MultiJson.load(test['response'])
          responses["#{response_key(request_key(request), response)} #{response['body'].sum}"] = nil
        end
        responses
      end

      def responses_performed_in_tests_and_documentation(tests)
        responses = {}
        tests.map do |location, test|
          request = MultiJson.load(test['request'])
          response = MultiJson.load(test['response'])
          if request['schema'] && response['schemas']
            responses["#{response_key(request_key(request), response)} #{response['body'].sum}"] = nil
          end
        end
        responses
      end

      def route_responses_in_documentation_and_performed_test(tests)
        routes = {}
        tests.map do |location, test|
          request = MultiJson.load(test['request'])
          response = MultiJson.load(test['response'])
          if request['schema'] && response['schemas']
            routes["#{response_key(request_key(request['schema']), response)} #{find_index(response)}"] = nil
          end
        end
        routes
      end

      def valid(tests)
        routes = {}
        tests.map do |location, test|
          request = MultiJson.load(test['request'])
          response = MultiJson.load(test['response'])
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
