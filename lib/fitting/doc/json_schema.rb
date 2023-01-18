require 'fitting/doc/step'
require 'fitting/doc/combination'

module Fitting
  class Doc
    class JsonSchema < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema)
        @step_cover_size = 0
        @step_key = json_schema
        @next_steps = []
        Fitting::Cover::JSONSchemaOneOf.new(json_schema).combi.each do |combination|
          @next_steps.push(Combination.new(combination[0], combination[1][0], combination[1][1]))
        end
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@step_key, log.body) == []
          @step_cover_size += 1
          @next_steps.each { |combination| combination.cover!(log) }
        else
          raise Fitting::Doc::JsonSchema::NotFound.new "json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"\
            "body: #{::JSON.pretty_generate(log.body)}\n\n"\
            "error #{::JSON.pretty_generate(JSON::Validator.fully_validate(@step_key, log.body))}"
        end
      rescue JSON::Schema::SchemaError, NoMethodError => e
        raise Fitting::Doc::JsonSchema::NotFound.new "json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"\
            "body: #{::JSON.pretty_generate(log.body)}\n\n"\
            "error #{e.message}"
        # rescue Fitting::Doc::Combination::NotFound => e
        #  raise Fitting::Doc::JsonSchema::NotFound.new "#{e.message}\n\nsource json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"\
      end

      def new_index_offset
        3
      end

      def mark_range(index, res)
        start_index = index
        end_index = start_index + 2

        (start_index..end_index).each do |i|
          res[i] = @step_cover_size
        end
      end

      def nocover!
        @step_cover_size = nil
      end

      def to_hash
        @step_key
      end
    end
  end
end
