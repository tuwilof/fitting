require 'fitting/doc/step'
require 'fitting/doc/json_schema'

module Fitting
  class Doc
    class ContentType < Step
      class NotFound < RuntimeError; end

      def initialize(content_type, subvalue)
        @step_key = content_type
        @next_steps = []
        @step_cover_size = 0
        return self if content_type != 'application/json'
        if subvalue.size == 1
          definitions = subvalue.inject({}) do |sum, sv|
            if sv['body']["definitions"] != nil
              sum.merge!(sv['body']["definitions"])
            end
            sum
          end

          if definitions && definitions != {}
            res = merge_definitions(subvalue[0], definitions)
            if res
              @next_steps.push(JsonSchema.new(
                {
                  "$schema" => "http://json-schema.org/draft-04/schema#",
                  "type" => "object"
                }.merge(res)
              ))
            else
              @next_steps.push(JsonSchema.new({}))
            end
          else
            @next_steps.push(JsonSchema.new(subvalue[0]['body']))
          end
        else
          definitions = subvalue.inject({}) do |sum, sv|
            if sv['body']["definitions"] != nil
              sum.merge!(sv['body']["definitions"])
            end
            sum
          end
          if definitions && definitions != {}
            @next_steps.push(JsonSchema.new(
              {
                "$schema" => "http://json-schema.org/draft-04/schema#",
                "type" => "object",
                "oneOf" => subvalue.inject([]) do |sum, sv|
                  res = merge_definitions(sv, definitions)
                  sum.push(res)
                end
              }
            ))
          else
            @next_steps.push(JsonSchema.new(
              {
                "$schema" => "http://json-schema.org/draft-04/schema#",
                "type" => "object",
                "oneOf" => subvalue.inject([]) do |sum, sv|
                  sum.push(check_body(sv['body']["properties"], sv))
                end
              }
            ))
          end
        end
      end

      def cover!(log)
        if @step_key == log.content_type && log.content_type == 'application/json'
          @step_cover_size += 1
          @next_steps.each { |json_schema| json_schema.cover!(log) }
        elsif @step_key != 'application/json' && log.content_type != 'application/json'
          @step_cover_size += 1
        end
      rescue Fitting::Doc::JsonSchema::NotFound => e
        raise NotFound.new "content-type: #{@step_key}\n\n"\
          "#{e.message}"
      end

      def merge_definitions(sv, definitions)
        res = sv['body']["properties"]
        definitions.each_pair do |key, value|
          while JSON.dump(res).include?("\"$ref\":\"#/definitions/#{key}\"") do
            new_res_array = JSON.dump(res).split('{')
            index = new_res_array.index { |js| js.include?("\"$ref\":\"#/definitions/#{key}\"") }
            if index != nil
              def_size = "\"$ref\":\"#/definitions/#{key}\"".size
              new_res_array[index] = JSON.dump(value)[1..-2] + new_res_array[index][def_size..-1]
              res = JSON.load(new_res_array.join("{"))
            end
          end
        end
        if res == nil
          nil
        else
          check_body(res, sv)
        end
      end

      def check_body(res, sv)
        if sv['body']["required"] == nil
          {
            "properties" => res
          }
        else
          {
            "properties" => res,
            "required" => sv['body']["required"]
          }
        end
      end
    end
  end
end
