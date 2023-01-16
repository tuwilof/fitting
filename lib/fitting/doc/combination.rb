require 'fitting/doc/step'

module Fitting
  class Doc
    class Combination < Step
      class NotFound < RuntimeError; end

      def initialize(json_schema, type, combination)
        @step_cover_size = 0
        @step_key = json_schema
        @next_steps = []
        @type = type
        @combination = combination
      end

      def cover!(log)
        if JSON::Validator.fully_validate(@step_key, log.body) == []
          @step_cover_size += 1
=begin
        else
          raise NotFound.new "combination: #{@combination}\n"\
            "combination type: #{@type}\n"\
            "combination json-schema: #{::JSON.pretty_generate(@step_key)}\n"\
            "combination error #{::JSON.pretty_generate(JSON::Validator.fully_validate(@step_key, log.body))}\n"\
            "body: #{::JSON.pretty_generate(log.body)}"
=end
        end
      end

      def report(res, index)
        res[index] = @step_cover_size
        [res, index]
      end
    end
  end
end
