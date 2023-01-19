require 'fitting/doc/step'
require 'fitting/cover/json_schema_enum'

module Fitting
  class Doc
    class CombinationOptional < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema, type, combination)
        @step_cover_size = 0
        @json_schema = json_schema
        @next_steps = []
        @type = type
        @step_key = combination
      end

      def cover!(log)
        error = JSON::Validator.fully_validate(@json_schema, log.body)
        if error == []
          @step_cover_size += 1
          nil
        end
      end

      def mark_required(index, res, schema)
        start_index = index + YAML.dump(schema["properties"]).split("\n").size - 1
        end_index = start_index + YAML.dump(schema["required"]).split("\n").size - 1
        (start_index..end_index).each do |i|
          res[i] = @step_cover_size
        end

        return if schema["required"].nil?

        schema["required"].each do |required|
          required_index = YAML.dump(schema["properties"]).split("\n").index { |key| key == "#{required}:" }
          break if required_index.nil?
          required_index -= 1
          res[index + required_index] = @step_cover_size
          res[index + required_index + 1] = @step_cover_size
          if schema["properties"][required]["type"] == "object"
            res[index + required_index + 2] = @step_cover_size
            new_index = index + required_index + 2
            mark_required_inst(new_index, res, schema["properties"][required])
          end
        end
      end

      def mark_required_inst(index, res, schema)
        start_index = index + YAML.dump(schema["properties"]).split("\n").size
        end_index = start_index + YAML.dump(schema["required"]).split("\n").size
        (start_index..end_index).each do |i|
          res[i] = @step_cover_size
        end

        return if schema["required"].nil?

        schema["required"].each do |required|
          required_index = YAML.dump(schema["properties"]).split("\n").index { |key| key == "#{required}:" }
          break if required_index.nil?
          res[index + required_index] = @step_cover_size
          res[index + required_index + 1] = @step_cover_size
          res[index + required_index + 2] = @step_cover_size if schema["properties"][required]["type"] == "string" && schema["properties"][required]["enum"]
          if schema["properties"][required]["type"] == "object"
            #res[index + required_index + 2] = @step_cover_size
            new_index = index + required_index + 2
            #mark_required(new_index, res, schema["properties"][required])
          elsif schema["properties"][required]["type"] == "string" && schema["properties"][required]["enum"]
            new_index = index + required_index + 2
            mark_enum(new_index, res, schema["properties"][required])
          end
        end
      end
    end
  end
end
