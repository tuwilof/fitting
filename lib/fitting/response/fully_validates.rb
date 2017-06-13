require 'json-schema'

module Fitting
  class Response
    class FullyValidates < Array
      def self.craft(schemas, body, strict)
        if schemas
          new(schemas.inject([]) do |res, schema|
            res.push(fully_validate(schema, body, strict))
          end)
        else
          @valid = false
          new
        end
      end

      def valid?
        @valid ||= any? { |fully_validate| fully_validate == [] }
      end

      def to_s
        @to_s ||= join("\n\n")
      end

      class << self
        def fully_validate(schema, body, strict)
          JSON::Validator.fully_validate(schema, body, strict: strict)
        rescue JSON::Schema::UriError
          []
        end
      end
    end
  end
end
