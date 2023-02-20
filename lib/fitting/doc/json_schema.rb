require 'fitting/doc/step'
require 'fitting/doc/combination_one_of'
require 'fitting/cover/json_schema_one_of'
require 'fitting/doc/combination_enum'
require 'fitting/cover/json_schema_enum'
require 'fitting/cover/json_schema'
require 'fitting/doc/combination_optional'
require 'json'
require 'json-schema'

module Fitting
  class Doc
    class JsonSchema < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema, super_schema)
        @super_schema = super_schema
        @logs = []
        @step_cover_size = 0
        @step_key = json_schema
        @next_steps = []
        @oneOf = false
        Fitting::Cover::JSONSchemaOneOf.new(json_schema).combi.each do |combination|
          @oneOf = true
          @next_steps.push(CombinationOneOf.new(combination[0], combination[1][0], combination[1][1], json_schema))
        end
        combinations = Fitting::Cover::JSONSchemaEnum.new(json_schema).combi
        if combinations.size > 1
          combinations.each do |comb|
            @next_steps.push(CombinationEnum.new(comb[0], comb[1][0], comb[1][1], json_schema))
          end
        end

        if json_schema['type'] != 'array'
          combinations = Fitting::Cover::JSONSchema.new(json_schema).combi
          combinations.each do |comb|
            @next_steps.push(CombinationOptional.new(comb[0], comb[1][0], comb[1][1], json_schema))
          end
        end
      end

      def cover!(log)
        if @super_schema
          @step_cover_size += 1
          @logs.push(log.body)
          @next_steps.each { |combination| combination.cover!(log) }
        elsif JSON::Validator.fully_validate(@step_key, log.body) == []
          @step_cover_size += 1
          @logs.push(log.body)
          @next_steps.each { |combination| combination.cover!(log) }
        else
          raise Fitting::Doc::JsonSchema::NotFound.new "json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"\
            "body: #{::JSON.pretty_generate(log.body)}\n\n"\
            "error #{JSON::Validator.fully_validate(@step_key, log.body).first}"
        end
      rescue JSON::Schema::SchemaError => e
        raise Fitting::Doc::JsonSchema::NotFound.new "json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"\
            "body: #{::JSON.pretty_generate(log.body)}\n\n"\
            "error #{e.message}"
      rescue Fitting::Doc::CombinationOneOf::NotFound => e
        raise Fitting::Doc::JsonSchema::NotFound.new "#{e.message}\n\nsource json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"
      end

      def logs
        @logs
      end

      def mark_range(index, res)
        start_index = index
        end_index = start_index + 2

        (start_index..end_index).each do |i|
          res[i] = @step_cover_size
        end

        if @step_key["required"]
          mark_required(end_index, res, @step_key)
        end
        end_index
      end

      def to_hash
        @step_key
      end

      def report(res, index)
        @index_before = index
        @res_before = [] + res

        index = mark_range(index, res)
        @index_medium = index
        @res_medium = [] + res

        if @next_steps != []
          new_index = index
          @next_steps.each do |next_step|
            if @oneOf
              res, new_index = next_step.report(res, new_index)
            else
              res, new_index = next_step.report(res, @index_before)
            end
          end
        end

        index += index_offset
        @index_after = index
        @res_after = [] + res
        [res, index]
      end
    end
  end
end
