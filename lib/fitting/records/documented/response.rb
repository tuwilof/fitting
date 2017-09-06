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
      end
    end
  end
end
