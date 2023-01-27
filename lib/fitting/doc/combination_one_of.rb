require 'fitting/doc/combination_step'
require 'fitting/cover/json_schema_enum'
require 'fitting/doc/combination_enum'
require 'fitting/cover/json_schema'
require 'fitting/doc/combination_optional'

module Fitting
  class Doc
    class CombinationOneOf < CombinationStep
      def initialize_combinations(combination, json_schema)
        combinations = Fitting::Cover::JSONSchemaEnum.new(@json_schema).combi
        if combinations.size > 1
          combinations.each do |comb|
            @next_steps.push(CombinationEnum.new(comb[0], "#{comb[1][0]}", "#{comb[1][1]}", json_schema))
          end
        end

        combinations = Fitting::Cover::JSONSchema.new(@json_schema).combi
        combinations.each do |comb|
          @next_steps.push(CombinationOptional.new(comb[0], "#{type}.#{comb[1][0]}", "#{combination}.#{comb[1][1]}", json_schema))
        end
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@json_schema, log.body) == []
          @step_cover_size += 1
          @logs.push(log.body)
          errors = @next_steps.inject([]) do |sum, combination|
            sum.push(combination.cover!(log))
          end.flatten.compact

          return if @next_steps.size == 0
          return unless @next_steps.size == errors.size

          error_message = ""
          errors.each do |error|
            error_message += "combination: #{error[:combination]}\n"\
            "combination type: #{error[:type]}\n"\
            "combination json-schema: #{::JSON.pretty_generate(error[:json_schema])}\n"\
            "combination error #{::JSON.pretty_generate(error[:error])}\n"\
            "combination body #{::JSON.pretty_generate(error[:body])}\n"
          end

          # raise NotFound.new "#{error_message}\n"\
          #  "source body: #{::JSON.pretty_generate(log.body)}"
        end
      end

      def mark_range(index, res)
        res[index + 1] = @step_cover_size
        if @json_schema && @json_schema["required"]
          mark_required(index + 1, res, @json_schema)
        end
      end
    end
  end
end
