module Fitting
  module Report
    module Response
      class Macro
        def initialize(tests)
          @json = responses(tests)
        end

        def responses(tests)
          data = {
            'not_documented' => {},
            'invalid' => {},
            'valid' => {}
          }

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
              full_responses["#{request['method']} #{request['path']} #{response.first}"] = (0..response.last-1).to_a
            end
          end

          if tests
            tests.map do |location, test|
              request = MultiJson.load(test['request'])
              response = MultiJson.load(test['response'])
              if request['schema'].nil?
                data['not_documented'][response_key(request, response)] = [location]
              else
                if response['schemas'].nil?
                  data['not_documented'][response_key(request['schema'], response)] = [location]
                else
                  responses_documented(location, response['valid'], data, response_key(request['schema'], response), full_responses, response)
                end
              end
            end
          end

          not_cover = {}
          full_responses.map do |response, date|
            date.map do |index|
              not_cover["#{response} #{index}"] = nil
            end
          end
          data['not_cover_where_either'] = not_cover
          data
        end

        def responses_documented(location, valid, data, name, full_responses, response)
          if full_responses[name]
            if valid
              full_responses[name].delete(find_index(response))
              push('valid', data, "#{name} #{find_index(response)}", location)
            else
              push('invalid', data, name, location)
            end
          end
        end

        def find_index(response)
          response['schemas'].size.times do |i|
            if response['fully_validates'][i] == []
              return i
            end
          end
        end

        def push(key, data, name, location)
          data[key] = if data[key][name]
            data[key].merge(name => data[key][name] + [location])
          else
            data[key].merge(name => [location])
          end
        end

        def request_key(request_data)
          "#{request_data['method']} #{request_data['path']}"
        end

        def response_key(request_data, response_data)
          "#{request_key(request_data)} #{response_data['status']}"
        end

        def to_hash
          @json
        end
      end
    end
  end
end
