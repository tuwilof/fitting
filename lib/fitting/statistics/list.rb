module Fitting
  class Statistics
    class List
      def initialize(coverage_fully, coverage_partially, coverage_non, max_response_path)
        @coverage_fully = coverage_fully
        @coverage_partially = coverage_partially
        @coverage_non = coverage_non
        @max_response_path = max_response_path
      end

      def to_s
        [
          coverage_fully_stat,
          coverage_partially_stat,
          coverage_non_stat
        ].compact.join("\n\n")
      end

      def coverage_fully_stat
        if @coverage_fully == []
          nil
        else
          [
            'Fully conforming requests:',
            craft(list_sort(@coverage_fully)),
          ].join("\n")
        end
      end

      def coverage_partially_stat
        if @coverage_partially == []
          nil
        else
          [
            'Partially conforming requests:',
            craft(list_sort(@coverage_partially)),
          ].join("\n")
        end
      end

      def coverage_non_stat
        if @coverage_non == []
          nil
        else
          [
            'Non-conforming requests:',
            craft(list_sort(@coverage_non)),
          ].join("\n")
        end
      end

      def craft(requests)
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
    end
  end
end
