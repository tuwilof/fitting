require 'fitting/doc/step'
require 'fitting/cover/json_schema_enum'

module Fitting
  class Doc
    class CombinationEnum < Step
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
        else
          bodies = custom_body(log.body)
          errors = []
          bodies.each do |body|
            error = JSON::Validator.fully_validate(@json_schema, body)
            if error == []
              @step_cover_size += 1
              nil
            else
              errors.push(
                {
                  combination: @step_key,
                  type: @type,
                  json_schema: @json_schema,
                  error: error,
                  body: body
                })
            end
          end

          if errors.size == bodies.size
            errors
          else
            nil
          end
        end
      end

      def find_keys
        new_keys = []
        if YAML.dump(@json_schema).include?("array")
          res = @json_schema
          @step_key.split('.').each do |key|
            if res[key].class == Hash && res[key] != nil
              if res[key].class == Hash && res[key]['type'] == 'array'
                new_keys.push(key)
                return new_keys
              else
                if key != 'properties'
                  new_keys.push(key)
                end
                res = res[key]
              end
            end
          end
        end
        []
      end

      def custom_body(body)
        bodies = []
        keys = find_keys
        if keys != []
          if keys.size == 1
            if body[keys[0]].size == 1
              return body
            else
              body[keys[0]].each do |bb|
                new_body = body.dup
                new_body.delete(keys[0])
                bodies.push(new_body.merge(keys[0] => bb))
              end
            end
          end
          return bodies
        end
        [body]
      end
    end
  end
end
