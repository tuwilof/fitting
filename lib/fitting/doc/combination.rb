require 'fitting/doc/step'

module Fitting
  class Doc
    class Combination < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema, type, combination)
        @step_cover_size = 0
        @json_schema = json_schema
        @next_steps = []
        @type = type
        @step_key = combination
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@json_schema, log.body) == []
          @step_cover_size += 1
=begin
        else
          raise NotFound.new "combination: #{@combination}\n"\
            "combination type: #{@type}\n"\
            "combination json-schema: #{::JSON.pretty_generate(@json_schema)}\n"\
            "combination error #{::JSON.pretty_generate(JSON::Validator.fully_validate(@json_schema, log.body))}\n"\
            "body: #{::JSON.pretty_generate(log.body)}"
=end
        end
      end

      def mark_range(index, res)
        res[index] = @step_cover_size
        if @json_schema["oneOf"][0]["required"]
          mark_required(index, res, @json_schema["oneOf"][0])
        end
      end

      def index_offset
        YAML.dump(@json_schema['oneOf'][0]).split("\n").size - 1
      end
    end
  end
end
