module Fitting
  module Report
    class Test
      def initialize(tests)
        documented = {}
        not_documented = {}

        tests.map do |location, test|
          request = MultiJson.load(test['request'])
          response = MultiJson.load(test['response'])
          if request['schema'].nil?
            url = "#{request['method']} #{request['path']}"
            not_documented[url] = {}
          else
            url = "#{request['schema']['method']} #{request['schema']['path']}"
            documented[url] = not_doc(request, response, documented, location)
          end
        end

        @json = {
          'requests' => {
            'documented' => documented,
            'not_documented' => not_documented
          }
        }
      end

      def not_doc(request, response, documented, location)
        code = response['status'].to_s
        valid = response['valid']
        url = "#{request['schema']['method']} #{request['schema']['path']}"
        local_tests = {}
        if documented[url]
          local_tests = documented[url]['responses'][code]['tests']
        end
        unless valid
          fully_validates = response['schemas'].map do |schema|
            MultiJson.dump(schema['fully_validate'])
          end

          schemas = response['schemas'].map do |schema|
            MultiJson.dump(schema['body'])
          end

          local_tests[location] = {
            'got' => response['body'],
            'diff' => fully_validates,
            'expected' => schemas
          }
        end

        valid = false if local_tests.present?

        {
          'responses' => {
            code => {
              'valid' => valid,
              'tests' => local_tests
            }
          }
        }
      end

      def to_hash
        @json
      end
    end
  end
end
