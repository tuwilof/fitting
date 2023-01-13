require 'fitting/doc/step'

module Fitting
  class Doc
    class Combination < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema, type, combination)
        @step_cover_size = 0
        @json_schema = json_schema
        @type = type
        @combination = combination
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@json_schema, log.body) == []
          @step_cover_size += 1
        else
          raise NotFound.new "combination: #{@combination}\n"\
            "combination type: #{@type}\n"\
            "combination json-schema: #{::JSON.pretty_generate(@json_schema)}\n"\
            "combination error #{::JSON.pretty_generate(JSON::Validator.fully_validate(@json_schema, log.body))}\n"\
            "body: #{::JSON.pretty_generate(log.body)}"
        end
      end
    end
  end
end
