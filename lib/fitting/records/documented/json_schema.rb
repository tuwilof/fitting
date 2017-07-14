require 'json-schema'

module Fitting
  class Records
    class Documented
      class JsonSchema
        attr_reader :bodies

        def initialize(json_schema)
          @json_schema = json_schema
          @bodies = []
        end

        def to_h
          @json_schema
        end

        def join(tested_body)
          return unless JSON::Validator.validate(@json_schema, tested_body.to_s)
          @bodies.push(tested_body)
          tested_body.add_json_schema(@json_schema)
        rescue JSON::Schema::UriError
          @bodies.push(tested_body)
          tested_body.add_json_schema(@json_schema)
        end
      end
    end
  end
end
