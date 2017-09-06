require 'json-schema'

module Fitting
  class Records
    class Documented
      class JsonSchema
        def initialize(json_schema)
          @json_schema = json_schema
        end

        def to_h
          @json_schema
        end
      end
    end
  end
end
