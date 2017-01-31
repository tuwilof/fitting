module Fitting
  class Report
    def initialize(tests)
      documented = {}
      not_documented = {}

      tests.map do |location, test|
        request = MultiJson.load(test['request'])
        response = MultiJson.load(test['response'])
        if request['schema'].nil?
          not_documented["#{request['method']} #{request['path']}"] = {}
        else
          status = "#{request['schema']['method']} #{request['schema']['path']}"
          documented[status] = not_doc(request, response, documented, location)
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

    def not_doc(request, response, documented, location)
      code = response['status'].to_s
      valid = response['valid']
      status = "#{request['schema']['method']} #{request['schema']['path']}"
      local_tests = {}
      if documented[status]
        local_tests = documented[status]['responses'][code]['tests']
      end
      unless valid
        fully_validates = response['schemas'].map do |schema|
          schema['fully_validate']
        end

        local_tests[location] = {
          'reality' => {
            'body' => response['body']
          },
          'fully_validates' => fully_validates.first
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
