module Fitting
  class Statistics
    class CoverErrorEnum
      def initialize(request_unit)
        @request_unit = request_unit
      end

      def to_s
        res = ''
        @request_unit.map do |request|
          request.responses.map do |response|
            next unless response.tested_bodies != []
            response.json_schemas.map do |json_schema|
              json_schema.combinations_with_enum.map do |combination|
                next unless combination.valid_bodies == []
                res += "request metohd: #{request.method}\nrequest path: #{request.path}\n"\
                        "response staus: #{response.status}\nsource json-schema: #{json_schema.json_schema}\n"\
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
