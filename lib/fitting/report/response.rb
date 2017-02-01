module Fitting
  module Report
    class Response
      def initialize(tests)
        @json = responses(tests)
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

      def to_hash
        @json
      end
    end
  end
end
