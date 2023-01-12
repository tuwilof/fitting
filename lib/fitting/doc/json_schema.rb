require 'fitting/doc/step'

module Fitting
  class Doc
    class JsonSchema < Step
      def initialize(json_schema)
        @step_cover_size = 0
        @step_key = json_schema
        @next_steps = []
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@step_key, log.body) == []
          @step_cover_size += 1
        end
      rescue
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
