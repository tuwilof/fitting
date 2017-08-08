require 'fitting/statistics/list'
require 'fitting/statistics/requests_stats'
require 'fitting/statistics/responses_stats'

module Fitting
  class Statistics
    class Analysis
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
      end

      def all
        check_responses
        [
          list_stat,
          requests_stats,
          responses_stats,
          great
        ].compact.join("\n\n")
      end

      def list_stat
        Fitting::Statistics::List.new(@coverage_fully, @coverage_partially, @coverage_non, @max_response_path).to_s
      end

      def requests_stats
        Fitting::Statistics::RequestsStats.new(@coverage_fully, @coverage_partially, @coverage_non, @requests).to_s
      end

      def responses_stats
        Fitting::Statistics::ResponsesStats.new(@cover_responses, @not_cover_responses, @all_responses).to_s
      end

      def great
        if @cover_responses == @all_responses
          'All responses are 100% valid! Great job!'
        else
          nil
        end
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

      def not_covered
        check_responses
        @not_covered_responses.join("\n") + "\n"
      end
    end
  end
end
