require 'fitting/doc/step'

module Fitting
  class Doc
    class JsonSchema < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema)
        @step_cover_size = 0
        @step_key = json_schema
        @next_steps = []
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@step_key, log.body) == []
          @step_cover_size += 1
        else
          raise NotFound.new "json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"\
            "body: #{::JSON.pretty_generate(log.body)}\n\n"\
            "error #{::JSON.pretty_generate(JSON::Validator.fully_validate(@step_key, log.body))}"
        end
      rescue JSON::Schema::SchemaError, NoMethodError => e
        raise NotFound.new "json-schema: #{::JSON.pretty_generate(@step_key)}\n\n"\
            "body: #{::JSON.pretty_generate(log.body)}\n\n"\
            "error #{e.message}"
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
