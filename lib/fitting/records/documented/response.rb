module Fitting
  class Records
    class Documented
      class Response
        attr_reader :status, :json_schemas

        def initialize(tomogram_response)
          @status = tomogram_response['status'].to_s
          @json_schemas = []
        end

        def add_json_schema(tomogram_response)
          @json_schemas.push(tomogram_response['body'])
        end
      end
    end
  end
end
