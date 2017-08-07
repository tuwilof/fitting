module Fitting
  class Statistics
    class List
      def initialize(requests)
        @requests = requests
        @all_responses = 0
        @cover_responses = 0
        @not_cover_responses = 0
        @max_response_path = 0
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
        [
          coverage_fully_stat,
          coverage_partially_stat,
          coverage_non_stat
        ].compact.join("\n\n")
      end

      def requests_stats
        [
          "API requests with fully implemented responses: #{@coverage_fully.size} (#{percent(@requests.size, @coverage_fully.size)}% of #{@requests.size}).",
          "API requests with partially implemented responses: #{@coverage_partially.size} (#{percent(@requests.size, @coverage_partially.size)}% of #{@requests.size}).",
          "API requests with no implemented responses: #{@coverage_non.size} (#{percent(@requests.size, @coverage_non.size)}% of #{@requests.size})."
        ].join("\n")
      end

      def responses_stats
        [
          "API responses conforming to the blueprint: #{@cover_responses} (#{percent(@all_responses, @cover_responses)}% of #{@all_responses}).",
          "API responses with validation errors or untested: #{@not_cover_responses} (#{percent(@all_responses, @not_cover_responses)}% of #{@all_responses})."
        ].join("\n")
      end

      def great
        if @cover_responses == @all_responses
          'All responses are 100% valid! Great job!'
        else
          nil
        end
      end

      def to_s(requests)
        requests.inject([]) do |res, request|
          res.push("#{request.method}\t#{request.path}#{responses_stat(request)}")
        end.join("\n")
      end

      def list_sort(requests)
        requests.sort do |first, second|
          first.path.to_s <=> second.path.to_s
        end
      end

      def responses_stat(request)
        tab = "\t" * ((@max_response_path - request.path.to_s.size / 8) + 3)
        tab + request.responses.to_a.inject([]) do |res, response|
          response.json_schemas.map do |json_schema|
            if json_schema.bodies == []
              res.push("✖ #{response.status}")
            else
              res.push("✔ #{response.status}")
            end
          end
          res
        end.join(' ')
      end

      def percent(divider, dividend)
        return 0 if divider == 0
        (dividend.to_f / divider.to_f * 100.0).round(2)
      end

      def coverage_fully_stat
        if @coverage_fully == []
          nil
        else
          [
            'Fully conforming requests:',
            to_s(list_sort(@coverage_fully)),
          ].join("\n")
        end
      end

      def coverage_partially_stat
        if @coverage_partially == []
          nil
        else
          [
            'Partially conforming requests:',
            to_s(list_sort(@coverage_partially)),
          ].join("\n")
        end
      end

      def coverage_non_stat
        if @coverage_non == []
          nil
        else
          [
            'Non-conforming requests:',
            to_s(list_sort(@coverage_non)),
          ].join("\n")
        end
      end

      def check_responses
        return if @ready

        @coverage_fully = []
        @coverage_non = []
        @coverage_partially = []
        @not_covered_responses = []
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
