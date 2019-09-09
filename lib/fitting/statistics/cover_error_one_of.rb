module Fitting
  class Statistics
    class CoverErrorOneOf
      def initialize(request_unit)
        @request_unit = request_unit
      end

      def to_s
        res = ''
        @request_unit.map do |request|
          request.responses.map do |response|
            next unless response.tested_bodies != []
            response.json_schemas.map do |json_schema|
              json_schema.combinations_with_one_of.map do |combination|
                next unless combination.valid_bodies == []
                res += "request method: #{request.method}\nrequest path: #{request.path}\n"\
                        "response status: #{response.status}\nsource json-schema: #{json_schema.json_schema}\n"\
                       "combination: #{combination.description}\nnew json-schema: #{combination.json_schema}\n\n"
              end
            end
          end
        end
        res
      end
    end
  end
end
