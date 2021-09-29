require 'json-schema'

module Fitting
  class Records
    class Unit
      class Combination
        attr_reader :description, :json_schema, :bodies

        def initialize(comb, bodies)
          @description = comb[1]
          @json_schema = comb[0]
          @bodies = bodies
        end

        def valid_bodies
          @valid_bodies ||= @bodies.inject([]) do |res, tested_body|
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
