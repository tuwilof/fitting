module Fitting
  class Statistics
    class List
      def initialize(coverage, max_response_path, depth)
        @coverage = coverage
        @max_response_path = max_response_path
        @depth = depth
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
        if @depth == 'valid'
          if json_schema.bodies == []
            res.push("✖ #{response.status}")
          else
            res.push("✔ #{response.status}")
          end
        elsif @depth == 'cover'
          res.push("#{json_schema.cover}% #{response.status}")
        elsif @depth == 'cover_enum'
          res.push("#{json_schema.cover_enum}% #{response.status}")
        elsif @depth == 'cover_one_of'
          res.push("#{json_schema.cover_one_of}% #{response.status}")
        end
      end
    end
  end
end
