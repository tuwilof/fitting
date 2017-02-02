require 'multi_json'

module Fitting
  module Report
    module Response
      class Micro
        def initialize(tests)
          @json = responses(tests)
        end

        def responses(tests)
          data = {}

          tests.map do |location, test|
            request = MultiJson.load(test['request'])
            response = MultiJson.load(test['response'])
            if request['schema'].nil?
              data[location] = {
                'status' => 'not_documented',
                'got' => response["body"],
              }
            else
              if response["schemas"].nil?
                data[location] = {
                  'status' => 'not_documented',
                  'got' => response["body"],
                }
              else
                responses_documented(location, data, response)
              end
            end
          end

          data
        end

        def responses_documented(location, data, response)
          if response['valid']
            expect_body = {}
            response['schemas'].map do |schema|
              if schema['fully_validate'] == []
                expect_body = schema['body']
              end
            end
            data[location] = {
              'status' => 'valid',
              'got' => response["body"],
              'expect' => MultiJson.dump(expect_body)
            }
          else
            fully_validates = response['schemas'].map do |schema|
              MultiJson.dump(schema['fully_validate'])
            end

            schemas = response['schemas'].map do |schema|
              MultiJson.dump(schema['body'])
            end

            data[location] = {
              'status' => 'invalid',
              'got' => response["body"],
              'diff' => fully_validates,
              'expected' => schemas
            }
          end
        end

        def to_hash
          @json
        end
      end
    end
  end
end
