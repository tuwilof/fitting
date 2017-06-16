require 'fitting/cover/json_schema'
require 'json-schema'

module Fitting
  class Cover
    class Response
      def initialize(response)
        @json_schemas = Fitting::Cover::JSONSchema.new(response.json_schema)
        @combinations = @json_schemas.combinations
        @flags = @json_schemas.json_schemas.map do |json_schema|
          JSON::Validator.validate(json_schema, response.body)
        end
      end

      attr_reader :json_schemas

      attr_reader :combinations

      attr_reader :flags

      def update(response)
        index = 0
        @json_schemas.json_schemas.map do |json_schema|
          flag = JSON::Validator.validate(json_schema, response.body)
          @flags[index] = @flags[index] || flag
          index += 1
        end
        self
      end
    end
  end
end
