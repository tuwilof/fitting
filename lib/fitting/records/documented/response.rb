require 'fitting/records/documented/json_schema'

module Fitting
  class Records
    class Documented
      class Response
        attr_reader :status, :json_schemas, :tested_responses

        def initialize(tomogram_response, request)
          @status = tomogram_response['status']
          @json_schemas = []
          @request = request
          @tested_responses = []
        end

        def add_json_schema(tomogram_response)
          json_schema = Fitting::Records::Documented::JsonSchema.new(tomogram_response['body'])
          @json_schemas.push(json_schema)
        end

        def join(tested_responses)
          tested_responses.map do |tested_response|
            next unless status == tested_response.status.to_s
            @tested_responses.push(tested_response)
            @json_schemas.map do |json_schema|
              json_schema.join(tested_response.body)
            end
          end
        end
      end
    end
  end
end
