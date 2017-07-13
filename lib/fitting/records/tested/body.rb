module Fitting
  class Records
    class Tested
      class Body
        attr_reader :json_schemas

        def initialize(body)
          @body = body
          @json_schemas = []
        end

        def add_json_schema(json_schema)
          @json_schemas.push(json_schema)
        end

        def to_s
          @body
        end
      end
    end
  end
end
