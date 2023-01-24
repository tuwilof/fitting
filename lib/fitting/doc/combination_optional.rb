require 'fitting/doc/step'
require 'fitting/cover/json_schema_enum'

module Fitting
  class Doc
    class CombinationOptional < Step
      class NotFound < RuntimeError; end

      attr_accessor :json_schema, :type, :logs

      def initialize(json_schema, type, combination, source_json_schema)
        @logs = []
        @step_cover_size = 0
        @json_schema = json_schema
        @next_steps = []
        @type = type
        @step_key = combination
        @source_json_schema = source_json_schema
      end

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

        @index_after = res_index + index + 1
        @res_after = [] + res
        [res, index]
      end
    end
  end
end
