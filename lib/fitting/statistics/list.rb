module Fitting
  class Statistics
    class List
      def initialize(coverage, max_response_path)
        @coverage = coverage
        @max_response_path = max_response_path
      end

      def to_s
        list_sort.inject([]) do |res, request|
          res.push("#{request.method}\t#{request.path}#{responses_stat(request)}")
        end.join("\n")
      end

      def list_sort
        @coverage.sort do |first, second|
          first.path.to_s <=> second.path.to_s
        end
      end

      def responses_stat(request)
        tab = "\t" * ((@max_response_path - request.path.to_s.size / 8) + 3)
        tab + request.responses.to_a.each_with_object([]) do |response, res|
          response_stat(response, res)
        end.join(' ')
      end

      private

      def response_stat(response, res)
        response.json_schemas.map do |json_schema|
          json_schema_stat(res, json_schema, response)
        end
      end

      def json_schema_stat(res, json_schema, response)
        if json_schema.bodies == []
          res.push("0% #{response.status}")
        else
          count = 0
          json_schema.combinations.map do |combination|
            count += 1 unless combination.valid_bodies ==[]
          end
          if json_schema.combinations.size == 0
            res.push("100% #{response.status}")
          else
            res.push("#{count * 100 / json_schema.combinations.size}% #{response.status}")
          end
        end
      end
    end
  end
end
