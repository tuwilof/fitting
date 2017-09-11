require 'json-schema'

module Fitting
  class Records
    class Unit
      class JsonSchema
        def initialize(json_schema, tested_bodies)
          @json_schema = json_schema
          @tested_bodies = tested_bodies
        end

        def bodies
          @bodies ||= @tested_bodies.inject([]) do |res, tested_body|
            begin
              next res unless JSON::Validator.validate(@json_schema, tested_body)
              res.push(tested_body)
            rescue JSON::Schema::UriError
              res.push(tested_body)
            end
          end
        end
      end
    end
  end
end
