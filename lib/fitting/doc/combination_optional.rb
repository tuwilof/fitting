require 'fitting/doc/combination_step'
require 'fitting/cover/json_schema_enum'

module Fitting
  class Doc
    class CombinationOptional < CombinationStep
      def cover!(log)
        error = JSON::Validator.fully_validate(@json_schema, log.body)
        if error == []
          @step_cover_size += 1
          @logs.push(log.body)
          nil
        end
      end

      def report(res, index)
        @index_before = index
        @res_before = [] + res
        @index_medium = index
        @res_medium = [] + res

        combinations = @step_key.split('.')
        elements = YAML.dump(@source_json_schema).split("\n")[1..-1]
        res_index = 0
        elements.each_with_index do |element, i|
          if element.include?(combinations[-1])
            res_index = i
            break
          end
        end

        res[res_index + index] = @step_cover_size
        res[res_index + index + 1] = @step_cover_size

        begin
        if @source_json_schema["properties"][combinations[-1]] && @source_json_schema["properties"][combinations[-1]].class == Hash && @source_json_schema["properties"][combinations[-1]]["type"] == "array"
          res[res_index + index + 2] = @step_cover_size
          res[res_index + index + 3] = @step_cover_size
          res[res_index + index + 4] = @step_cover_size

          schema = @source_json_schema["properties"][combinations[-1]]['items']
          mark_required(res_index + index + 4, res, schema)
        elsif @source_json_schema["properties"][combinations[-1]] && @source_json_schema["properties"][combinations[-1]].class == Hash && @source_json_schema["properties"][combinations[-1]]["type"] == "object"
          schema = @source_json_schema["properties"][combinations[-1]]
          res[res_index + index + 2] = @step_cover_size
          mark_required(res_index + index + 2, res, schema)
        end
        rescue TypeError
          byebug
        end

        @index_after = res_index + index + 4
        @res_after = [] + res
        [res, index]
      end
    end
  end
end
