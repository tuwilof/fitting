require 'json-schema'

module Fitting
  class Response
    class FullyValidates < Array
      def self.craft(schemas, body)
        new(schemas.inject([]) do |res, schema|
          res.push(JSON::Validator.fully_validate(schema, body))
        end)
      end

      def valid?
        @valid ||= any? { |fully_validate| fully_validate == [] }
      end

      def to_s
        @to_s ||= inject("") do |res, fully_validate|
          res + "#{fully_validate.join("\n")}\n\n"
        end
      end
    end
  end
end
