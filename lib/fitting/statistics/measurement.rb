module Fitting
  class Statistics
    class Measurement
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

        @requests.to_a.map do |request|
          if request.state == 'fully'
            @coverage_fully.push(request)
          elsif request.state == 'partially'
            @coverage_partially.push(request)
          elsif request.state == 'non'
            @coverage_non.push(request)
          end
          if request.path.to_s.size / 8 > @max_response_path
            @max_response_path = request.path.to_s.size / 8
          end
          request.responses.to_a.map do |response|
            json_schema_index = 0
            response.json_schemas.map do |json_schema|
              if json_schema.bodies == []
                @not_cover_responses += 1
                @not_covered_responses.push("#{request.method}\t#{request.path} #{response.status} #{json_schema_index}")
              else
                @cover_responses += 1
              end
              @all_responses += 1
              json_schema_index += 1
            end
          end
        end

        @ready = true
      end
    end
  end
end
