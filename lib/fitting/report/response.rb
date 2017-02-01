module Fitting
  module Report
    class Response
      def initialize(tests)
        @json = responses(tests)
      end

      def responses(tests)
        data = {
          'not_documented' => {},
          'documented' => {}
        }

        tests.map do |location, test|
          request = MultiJson.load(test['request'])
          response = MultiJson.load(test['response'])
          if request['schema'].nil?
            data['not_documented'][response_key(request, response)] = location
          else
            if response["schemas"].nil?
              data['not_documented'][response_key(request['schema'], response)] = {}
            else
              if data['documented'][response_key(request['schema'], response)]
                before = data['documented'][response_key(request['schema'], response)]
              else
                before = {
                  'invalid' => {},
                  'valid' => {}
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
            'invalid' => before['invalid'],
            'valid' => before['valid'].merge(location => {})
          }
        else
          {
            'invalid' => before['invalid'].merge(location => {}),
            'valid' => before['valid']
          }
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
