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
        if @json_schema["oneOf"][0]["required"]
          res[index] = @step_cover_size
          mark_required(index, res, @json_schema["oneOf"][0])
        else
          res[index] = @step_cover_size
        end

      end

      def mark_required(index, res, schema)
        start_index = index + YAML.dump(schema["properties"]).split("\n").size
        end_index = start_index + YAML.dump(schema["required"]).split("\n").size - 1
        (start_index..end_index).each do |i|
          res[i] = @step_cover_size
        end

        return if schema["required"].nil?

        schema["required"].each do |required|
          required_index = YAML.dump(schema["properties"]).split("\n").index { |key| key == "#{required}:" }
          break if required_index.nil?
          res[index + required_index] = @step_cover_size
          res[index + required_index + 1] = @step_cover_size
          if schema["properties"][required]["type"] == "object"
            res[index + required_index + 2] = @step_cover_size
            new_index = index + required_index + 2
            mark_required(new_index, res, schema["properties"][required])
          end
        end
      end

      def index_offset
        YAML.dump(@json_schema['oneOf'][0]).split("\n").size - 1
      end
    end
  end
end
