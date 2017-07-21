module Fitting
  class Records
    class Statistics
      def initialize(requests)
        @requests = requests
        @all_responses = 0
        @cover_responses = 0
        @not_cover_responses = 0
        @max_response_path = 0
      end

      def to_s(requests)
        requests.inject([]) do |res, request|
          res.push("#{request.method}\t#{request.path}#{responses_stat(request)}")
        end.join("\n")
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

      def statistics_with_conformity_lists
        check_responses
        [
          list_stat,
          requests_stats,
          responses_stats
        ].join("\n\n")
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
          "API requests with fully implemented responses: #{coverage_fully.size} (#{percent(@requests.size, coverage_fully.size)}% of #{@requests.size}).",
          "API requests with partially implemented responses: #{coverage_partially.size} (#{percent(@requests.size, coverage_partially.size)}% of #{@requests.size}).",
          "API requests with no implemented responses: #{coverage_non.size} (#{percent(@requests.size, coverage_non.size)}% of #{@requests.size})."
        ].join("\n")
      end

      def responses_stats
        [
          "API responses conforming to the blueprint: #{@cover_responses} (#{percent(@all_responses, @cover_responses)}% of #{@all_responses}).",
          "API responses with validation errors or untested: #{@not_cover_responses} (#{percent(@all_responses, @not_cover_responses)}% of #{@all_responses})."
        ].join("\n")
      end

      def coverage_fully_stat
        if coverage_fully == []
          nil
        else
          [
            'Fully conforming requests:',
            to_s(coverage_fully),
          ].join("\n")
        end
      end

      def coverage_partially_stat
        if coverage_partially == []
          nil
        else
          [
            'Partially conforming requests:',
            to_s(coverage_partially),
          ].join("\n")
        end
      end

      def coverage_non_stat
        if coverage_non == []
          nil
        else
          [
            'Non-conforming requests:',
            to_s(coverage_non),
          ].join("\n")
        end
      end

      def check_responses
        @requests.to_a.map do |request|
          if request.path.to_s.size / 8 > @max_response_path
            @max_response_path = request.path.to_s.size / 8
          end
          request.responses.to_a.map do |response|
            response.json_schemas.map do |json_schema|
              if json_schema.bodies == []
                @not_cover_responses += 1
              else
                @cover_responses += 1
              end
              @all_responses += 1
            end
          end
        end
      end

      def coverage_fully
        @coverage_fully ||= @requests.inject([]) do |res, request|
          next res unless request.state == 'fully'
          res.push(request)
        end
      end

      def coverage_non
        @coverage_non ||= @requests.inject([]) do |res, request|
          next res unless request.state == 'non'
          res.push(request)
        end
      end

      def coverage_partially
        @coverage_partially ||= @requests.inject([]) do |res, request|
          next res unless request.state == 'partially'
          res.push(request)
        end
      end
    end
  end
end
