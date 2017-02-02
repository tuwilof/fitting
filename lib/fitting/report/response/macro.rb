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

          tests.map do |location, test|
            request = MultiJson.load(test['request'])
            response = MultiJson.load(test['response'])
            if request['schema'].nil?
              data['not_documented'][response_key(request, response)] = [location]
            else
              if response["schemas"].nil?
                data['not_documented'][response_key(request['schema'], response)] = [location]
              else
                responses_documented(location, response['valid'], data, response_key(request['schema'], response))
              end
            end
          end

          data
        end

        def responses_documented(location, valid, data, name)
          if valid
            push('valid', data, name, location)
          else
            push('invalid', data, name, location)
          end
        end

        def push(key, data, name, location)
          if data[key][name]
            data[key] = data[key].merge(name => data[key][name] + [location])
          else
            data[key] = data[key].merge(name => [location])
          end
        end

        def request_key(request_data)
          "#{request_data['method']} #{request_data['path']}"
        end

        def response_key(request_data, response_data)
          "#{request_key(request_data)} #{response_data["status"]}"
        end

        def to_hash
          @json
        end
      end
    end
  end
end
