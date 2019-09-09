module Fitting
  class Statistics
    class MeasurementCoverOneOf
      attr_reader :requests, :all_responses, :cover_responses, :not_cover_responses, :max_response_path,
                  :coverage_fully, :coverage_non, :coverage_partially, :not_covered_responses

      def initialize(requests)
        @requests = requests
        @all_responses = 0
        @cover_responses = 0
        @not_cover_responses = 0
        @max_response_path = 0
        @coverage_fully = []
        @coverage_non = []
        @coverage_partially = []
        @not_covered_responses = []
        check_responses
      end

      def check_responses
        return if @ready

        @requests.map do |request|
          chech_request(request)
        end

        @ready = true
      end

      private

      def chech_request(request)
        check_cover(request)
        coverage_push(request)

        @max_response_path = request.path.to_s.size / 8 if request.path.to_s.size / 8 > @max_response_path
        request.responses.map do |response|
          check_response(response, request)
        end
      end

      def check_response(response, request)
        json_schema_index = 0
        response.json_schemas.map do |json_schema|
          json_schema_index = check_json_schema(json_schema, request, response, json_schema_index)
        end
      end

      def check_json_schema(json_schema, request, response, json_schema_index)
        if json_schema.cover_one_of != 100
          @not_cover_responses += 1
          @not_covered_responses.push("#{request.method}\t#{request.path} #{response.status} #{json_schema_index}")
        else
          @cover_responses += 1
        end
        @all_responses += 1
        json_schema_index + 1
      end

      def coverage_push(request)
        if @all == @cover
          @coverage_fully.push(request)
        elsif @all == @not_cover
          @coverage_non.push(request)
        else
          @coverage_partially.push(request)
        end
      end

      def check_cover(request)
        @all = 0
        @cover = 0
        @not_cover = 0

        request.responses.map do |response|
          response.json_schemas.map do |json_schema|
            count_cover(json_schema)
          end
        end
      end

      def count_cover(json_schema)
        @all += 1
        if json_schema.cover_one_of != 100
          @not_cover += 1
        else
          @cover += 1
        end
      end
    end
  end
end
