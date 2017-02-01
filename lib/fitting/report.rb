module Fitting
  class Report
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
        'statistics' => statistics(documented),
        'requests' => {
          'documented' => documented,
          'not_documented' => not_documented
        }
      }
    end

    def requests_responses(tests)
      data = {
        'request' => requests(tests),
        'response' => responses(tests)
      }
      data
    end

    def requests(tests)
      data = {
        'documented' => {},
        'not_documented' => {}
      }

      tests.map do |_location, test|
        request = MultiJson.load(test['request'])
        if request['schema'].nil?
          data['not_documented'][request_key(request)] = {}
        else
          data['documented'][request_key(request['schema'])] = {}
        end
      end

      data
    end

    def responses(tests)
      data = {
        'documented' => {},
        'not_documented' => {}
      }

      tests.map do |location, test|
        request = MultiJson.load(test['request'])
        response = MultiJson.load(test['response'])
        if request['schema'].nil?
          data['not_documented'][response_key(request, response)] = {}
        else
          if response["schemas"].nil?
            data['not_documented'][response_key(request['schema'], response)] = {}
          else
            if data['documented'][response_key(request['schema'], response)]
              before = data['documented'][response_key(request['schema'], response)]
            else
              before = {
                'valid' => {},
                'invalid' => {}
              }
            end
            data['documented'][response_key(request['schema'], response)] = responses_documented(location, response['valid'], before)
          end
        end
      end

      data
    end

    def responses_documented(location, valid, before)
      if valid
        {
          'valid' => before['valid'].merge(location => {}),
          'invalid' => before['invalid']
        }
      else
        {
          'valid' => before['valid'],
          'invalid' => before['invalid'].merge(location => {})
        }
      end
    end

    def request_key(request_data)
      "#{request_data['method']} #{request_data['path']}"
    end

    def response_key(request_data, response_data)
      "#{request_key(request_data)} #{response_data["status"]}"
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
          'got' =>  response['body'],
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

    def statistics(documented)
      sttstcs = {
        'responses' => {
          'valid' => 0,
          'invalid' => 0,
          'all' => 0
        }
      }
      documented.map do |request|
        request.last['responses'].map do |response|
          if response.last['valid']
            sttstcs['responses']['valid'] += 1
          else
            sttstcs['responses']['invalid'] += 1
          end
          sttstcs['responses']['all'] += 1
        end
      end
      sttstcs
    end

    def to_hash
      @json
    end
  end
end
