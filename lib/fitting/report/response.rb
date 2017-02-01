module Fitting
  module Report
    class Response
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
          if data['valid'][name]
            data['valid'] = data['valid'].merge(name =>  data['valid'][name] + [location])
          else
            data['valid'] = data['valid'].merge(name => [location])
          end
        else
          if data['invalid'][name]
            data['invalid'] = data['invalid'].merge(name =>  data['invalid'][name] + [location])
          else
            data['invalid'] = data['invalid'].merge(name => [location])
          end
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
