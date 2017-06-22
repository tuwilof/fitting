require 'fitting/cover/json_schema'
require 'json-schema'

module Fitting
  class Cover
    class Response
      def initialize(response)
        @cover_json_schemas = Fitting::Cover::JSONSchema.new(response.json_schema)
        @json_schemas = @cover_json_schemas.json_schemas + [response.json_schema]
        @combinations = @cover_json_schemas.combinations
        @flags = @cover_json_schemas.json_schemas.map do |json_schema|
          JSON::Validator.validate(json_schema, response.body)
        end
      end

      attr_reader :json_schemas

      attr_reader :combinations

      attr_reader :flags

      def update(response)
        index = 0
        @cover_json_schemas.json_schemas.map do |json_schema|
          flag = JSON::Validator.validate(json_schema, response.body)
          @flags[index] = @flags[index] || flag
          index += 1
        end
        self
      end

      def to_hash
        {
          'json_schemas' => json_schemas,
          'combinations' => combinations,
          'flags' => flags
        }
      end
    end
  end
end
