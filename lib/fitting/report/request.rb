module Fitting
  module Report
    class Request
      def initialize(tests)
        @json = requests(tests)
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

      def request_key(request_data)
        "#{request_data['method']} #{request_data['path']}"
      end

      def to_hash
        @json
      end
    end
  end
end
