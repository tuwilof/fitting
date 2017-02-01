module Fitting
  module Report
    class TestResponse
      def initialize(tests)
        @json = responses(tests)
      end

      def responses(tests)
        data = {}

        tests.map do |location, test|
          request = MultiJson.load(test['request'])
          response = MultiJson.load(test['response'])
          if request['schema'].nil?
            data[location] = {'status' => 'not_documented'}
          else
            if response["schemas"].nil?
              data[location] = {'status' => 'not_documented'}
            else
              responses_documented(location, response['valid'], data)
            end
          end
        end

        data
      end

      def responses_documented(location, valid, data)
        if valid
          data[location] = {'status' => 'valid'}
        else
          data[location] = {'status' => 'invalid'}
        end
      end

      def to_hash
        @json
      end
    end
  end
end
