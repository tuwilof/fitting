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
      end
    end
  end
end
