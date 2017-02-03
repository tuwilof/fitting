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

          not_cover = {}
          full_responses.map do |response, date|
            date['cases'].map do |one_case|
              if not_cover["#{response} #{one_case}"]
                not_cover["#{response} #{one_case}"] = not_cover["#{response} #{one_case}"] + [date['test']]
              else
                not_cover["#{response} #{one_case}"] = [date['test']]
              end
            end
          end
          data['not_cover_where_either'] = not_cover
          data
        end

        def responses_documented(location, valid, data, name, full_responses, response)
          if valid
            unless full_responses[name]
              full_responses[name] = {}
              full_responses[name]['cases'] = (0..response['schemas'].size-1).to_a
            end
            full_responses[name]['test'] = location
            full_responses[name]['cases'].delete(find_index(response))
            push('valid', data, "#{name} #{find_index(response)}", location)
          else
            push('invalid', data, name, location)
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
