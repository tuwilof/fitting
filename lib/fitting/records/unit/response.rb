require 'fitting/records/unit/json_schema'

module Fitting
  class Records
    class Unit
      class Response
        def initialize(documented_response, tested_responses)
          @documented_response = documented_response
          @tested_responses = tested_responses
        end

        def status
          @status ||= @documented_response.status.to_s
        end

        def json_schemas
          @json_schemas ||= @documented_response.json_schemas.inject([]) do |res, documented_json_schema|
            res.push(Fitting::Records::Unit::JsonSchema.new(documented_json_schema.to_h, tested_bodies))
          end
        end

        def tested_bodies
          @tested_bodies ||= @tested_responses.inject([]) do |res, tested_response|
            next res unless status == tested_response.status.to_s
            res.push(tested_response.body)
          end
        end
      end
    end
  end
end
