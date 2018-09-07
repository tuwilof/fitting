require 'json-schema'
require 'fitting/cover/json_schema'
require 'fitting/records/unit/combination'

module Fitting
  class Records
    class Unit
      class JsonSchema
        attr_reader :json_schema

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

        def combinations
          return @combinations if @combinations
          @combinations = []
          cover_json_schema = Fitting::Cover::JSONSchema.new(@json_schema)
          cover_json_schema.combi.map do |comb|
            @combinations.push(Fitting::Records::Unit::Combination.new(
              comb,
                                 bodies
            ))
          end
          @combinations
        end

        def cover
          @cover ||= if bodies == []
                       0
                     else
                       count = 0
                       combinations.map do |combination|
                         count += 1 unless combination.valid_bodies == []
                       end
                       (count + 1) * 100 / (combinations.size + 1)
                     end
        end
      end
    end
  end
end
